#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then

echo """
  install/utils/distro-downloader/download_distro.sh - usage:

  download_distro.sh <OUTPUT-DIR> <BASE_URL>
  
  OUTPUT-DIR
    Where the distro.local.json will be generated and where all distro assets will be downloaded.
  BASE_URL
    Where the distro.local.json should download the distro assets in this network (_i.e. Package mirroring server url)

  Supported Variables:
    TIPI_DISTRO_JSON -  (default: latest from offical cmake-re release)
    TIPI_DISTRO_MODE - (default: "default")
    TIPI_INSTALL_SOURCE - url to release package (default: latest from offical cmake-re release)
    TIPI_CLIENT_INSTALL_SCRIPT_SOURCE - url to client install script (default: latest from offical cmake-re release)
    TIPI_CONTAINER_INSTALL_SCRIPT - url to container install script (default: centos.sh latest from offical cmake-re release)
"""
exit 1
fi

DISTRO_URL="${TIPI_DISTRO_JSON:-https://raw.githubusercontent.com/tipi-build/distro/refs/heads/main/distro.json}"

RAW_DIR=${1:-.}
CLEANED_DIR=$(echo "$RAW_DIR" | tr -s '/')
CLEANED_DIR="${CLEANED_DIR%/}"
DISTRO_DOWNLOAD_OUTPUT_DIR=${CLEANED_DIR:-/}

TOOLS_DIR="${DISTRO_DOWNLOAD_OUTPUT_DIR}/"
DISTRO_JSON="${DISTRO_DOWNLOAD_OUTPUT_DIR}/distro.json"
DISTRO_LOCAL="${TOOLS_DIR}/distro.local.json"

BASE_URL=${2:-"file://${TOOLS_DIR}"}
BASE_URL="${BASE_URL%/}" # drop any trailing slashes

TIPI_INSTALL_SOURCE="${TIPI_INSTALL_SOURCE:-https://github.com/tipi-build/cli/releases/download/v0.0.85/tipi-v0.0.85-linux-x86_64.zip}"
TIPI_CLIENT_INSTALL_SCRIPT_SOURCE="${TIPI_CLIENT_INSTALL_SCRIPT_SOURCE:-https://raw.githubusercontent.com/tipi-build/cli/refs/heads/master/install/install_for_macos_linux.sh}"
TIPI_CONTAINER_INSTALL_SCRIPT="${TIPI_CONTAINER_INSTALL_SCRIPT:-https://raw.githubusercontent.com/tipi-build/cli/master/install/container/centos.sh}"

# ── helpers ──────────────────────────────────────────────────────────────────

red()   { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
cyan()  { printf '\033[0;36m%s\033[0m\n' "$*"; }
warn()  { printf '\033[0;33mWARN: %s\033[0m\n' "$*" >&2; }

require() {
  command -v "$1" &>/dev/null || { red "Required tool not found: $1"; exit 1; }
}

# ── pre-flight ────────────────────────────────────────────────────────────────

require curl
require jq

mkdir -p "$TOOLS_DIR"

# ── 1. Download distro.json ───────────────────────────────────────────────────

cyan "==> Downloading distro.json from cmake-re at $DISTRO_URL..."
curl -fsSL "$DISTRO_URL" -o "$DISTRO_JSON"
green "    Saved to $DISTRO_JSON"

# ── 2. Resolve mode filter (optional) ────────────────────────────────────────

MODE="${TIPI_DISTRO_MODE:-default}"

if [[ "$MODE" = "all" ]]; then
  cyan "==> No TIPI_DISTRO_MODE set — downloading all tools"
  MODE_TOOLS_JSON="null"
  # Collect the tool names for this mode into a bash array
  mapfile -t MODE_TOOLS < <(jq -r "$DISTRO_JSON")
  cyan "==> Mode '$MODE' selected — filtering to: ${MODE_TOOLS[*]}"
elif [[ -n "$MODE" ]] ; then
  # Validate the mode exists in the JSON
  mode_exists=$(jq -r --arg m "$MODE" 'if .modes[$m] then "yes" else "no" end' "$DISTRO_JSON")
  if [[ "$mode_exists" != "yes" ]]; then
    red "Error: mode '$MODE' not found in distro.json"
    echo "Available modes: $(jq -r '.modes | keys | join(", ")' "$DISTRO_JSON")"
    exit 1
  fi

  # Collect the tool names for this mode into a bash array
  mapfile -t MODE_TOOLS < <(jq -r --arg m "$MODE" '.modes[$m][]' "$DISTRO_JSON")
  cyan "==> Mode '$MODE' selected — filtering to: ${MODE_TOOLS[*]}"

  # Build a jq-compatible JSON array of tool names for filtering
  MODE_TOOLS_JSON=$(jq -n --argjson tools "$(printf '%s\n' "${MODE_TOOLS[@]}" | jq -R . | jq -s .)" '$tools')
fi

# ── 2b. Resolve platform filter (optional) ───────────────────────────────────

PLATFORM="${TIPI_DISTRO_PLATFORM:-}"

if [[ -n "$PLATFORM" ]]; then
  cyan "==> Platform '$PLATFORM' selected — only '$PLATFORM' and 'all' platform entries will be downloaded"
else
  cyan "==> No TIPI_DISTRO_PLATFORM set — downloading all platforms (including 'all')"
fi

# ── 3. Collect URLs (filtered by mode and/or platform) ───────────────────────

mapfile -t URLS < <(jq -r --argjson filter "$MODE_TOOLS_JSON" --arg platform "$PLATFORM" '
  .distro[]
  | select(
      if $filter == null then true
      else .name as $n | ($filter | index($n)) != null
      end
    )
  | .platforms
  | to_entries[]
  | select(
      # "all" platform entries are unconditionally included
      .key == "all"
      or
      if $platform == "" then true
      else .key == $platform
      end
    )
  | .value
  | to_entries[]
  | .value.url
  | select(. != null)
' "$DISTRO_JSON")

total="${#URLS[@]}"
cyan "==> Found $total tool archive(s) to download"

# ── 4. Download tool archives in parallel ────────────────────────────────────

# Max simultaneous downloads (default 8, override with TIPI_DOWNLOAD_JOBS)
MAX_JOBS="${TIPI_DOWNLOAD_JOBS:-8}"

# Temp file to collect failures from subshells
FAIL_LOG="$(mktemp)"
trap 'rm -f "$FAIL_LOG"' EXIT

# Semaphore: wait until fewer than MAX_JOBS background jobs are running
_throttle() {
  while (( $(jobs -rp | wc -l) >= MAX_JOBS )); do
    wait -n 2>/dev/null || true
  done
}

declare -A PIDS   # pid → filename, for result reporting

# Also Download cmake-re and install scripts
URLS+=("${TIPI_INSTALL_SOURCE}")
URLS+=("${TIPI_CONTAINER_INSTALL_SCRIPT}")
URLS+=("${TIPI_CLIENT_INSTALL_SCRIPT_SOURCE}")

for url in "${URLS[@]}"; do
  filename="$(basename "$url")"
  dest="$TOOLS_DIR/$filename"

  if [[ -f "$dest" ]]; then
    echo "  [skip]     $filename  (already exists)"
    continue
  fi

  _throttle
  echo "  [start]    $filename"
  (
    if curl -fsSL --retry 3 --retry-delay 2 "$url" -o "$dest"; then
      echo "  [done]     $filename"
    else
      warn "Failed to download: $url"
      rm -f "$dest"
      echo "$url" >> "$FAIL_LOG"
    fi
  ) &
  PIDS[$!]="$filename"
done

# Wait for all remaining background jobs to finish
wait

failed=$(wc -l < "$FAIL_LOG" | tr -d ' ')
if (( failed > 0 )); then
  warn "$failed download(s) failed:"
  while IFS= read -r url; do
    warn "  $url"
  done < "$FAIL_LOG"
fi

# ── 5. Rewrite distro.json with formatted URLs (strip to mode if set) ────────

cyan "==> Writing $DISTRO_LOCAL with rewritten URLs..."

jq --arg base_url "$BASE_URL" --argjson filter "$MODE_TOOLS_JSON" --arg platform "$PLATFORM" '
  # Keep only the relevant mode entry (or all modes if no filter)
  .modes |= (
    if $filter == null then .
    else
      to_entries
      | map(select(
          .value | (map(. as $t | ($filter | index($t)) != null) | any)
        ))
      | from_entries
    end
  )
  |
  # Strip distro entries not in the mode filter
  .distro |= map(
    select(
      if $filter == null then true
      else .name as $n | ($filter | index($n)) != null
      end
    )
  )
  |
  # Strip platforms not matching the platform filter.
  # "all" platform entries are unconditionally kept — they are platform-agnostic.
  .distro[] |= (
    .platforms |= with_entries(
      select(
        .key == "all"
        or
        if $platform == "" then true
        else .key == $platform
        end
      )
    )
  )
  |
  # Rewrite all url fields using the normalized base_url
  .distro[] |= (
    .platforms |= with_entries(
      .value |= with_entries(
        if (.value | type) == "object" and .value.url then
          .value.url |= ($base_url + "/" + (. | split("/") | last))
        else
          .
        end
      )
    )
  )
' "$DISTRO_JSON" > "$DISTRO_LOCAL"

rm "$DISTRO_JSON"

# Creating sha1sum named install scripts to invalidate Docker build cache
TIPI_CLIENT_INSTALL_SCRIPT_SOURCE_PATH=$TOOLS_DIR/$(basename "$TIPI_CLIENT_INSTALL_SCRIPT_SOURCE")
TIPI_CONTAINER_INSTALL_SCRIPT_PATH=$TOOLS_DIR/$(basename "$TIPI_CONTAINER_INSTALL_SCRIPT")
#TIPI_UTIL_LINUX_SOURCES_MIRROR_PATH=$TOOLS_DIR/$(basename "$TIPI_UTIL_LINUX_SOURCES_MIRROR")

TIPI_CLIENT_INSTALL_SCRIPT_SOURCE_SHA1SUM=$(sha1sum ${TIPI_CLIENT_INSTALL_SCRIPT_SOURCE_PATH} | cut -d ' ' -f 1)
TIPI_CONTAINER_INSTALL_SCRIPT_SHA1SUM=$(sha1sum ${TIPI_CONTAINER_INSTALL_SCRIPT_PATH} | cut -d ' ' -f 1)

mv $TIPI_CLIENT_INSTALL_SCRIPT_SOURCE_PATH "$TOOLS_DIR/$TIPI_CLIENT_INSTALL_SCRIPT_SOURCE_SHA1SUM-$(basename "$TIPI_CLIENT_INSTALL_SCRIPT_SOURCE")"
mv $TIPI_CONTAINER_INSTALL_SCRIPT_PATH "$TOOLS_DIR/$TIPI_CONTAINER_INSTALL_SCRIPT_SHA1SUM-$(basename "$TIPI_CONTAINER_INSTALL_SCRIPT")"

# Moving release binary as release name independent to ensure linux-offline.Dockerfile is an up-to-date example
rm -f $TOOLS_DIR/tipi-linux.zip && mv $TOOLS_DIR/$(basename "$TIPI_INSTALL_SOURCE") $TOOLS_DIR/tipi-linux.zip
TIPI_INSTALL_SOURCE=${BASE_URL}/tipi-linux.zip

TIPI_DISTRO_JSON_SHA1=$(sha1sum ${DISTRO_LOCAL} | cut -d ' ' -f 1)

green "==> Done!"
echo ""
echo "  Original distro :  $DISTRO_JSON, removed."
echo "  Local TIPI_DISTRO_JSON :  $DISTRO_LOCAL"
echo "  Local TIPI_DISTRO_JSON_SHA1   :  $TIPI_DISTRO_JSON_SHA1"
echo "  cmake-re release:  $(basename "$TIPI_INSTALL_SOURCE")"
echo "  Distro archive   :  $TOOLS_DIR"
echo "  Base URL        :  $BASE_URL"
if [[ -n "$MODE" ]]; then
  echo "  Mode filter     :  $MODE  (${#MODE_TOOLS[@]} tools)"
fi
if [[ -n "$PLATFORM" ]]; then
  echo "  Platform filter :  $PLATFORM  (+ 'all')"
fi
echo ""
echo "Use '$DISTRO_LOCAL' in your cmake-re configuration to point at your local TIPI_DISTRO_JSON hosting."
echo "Patch this in your Dockerfile : "
echo """
  ENV TIPI_DISTRO_MODE=${MODE}
  ENV TIPI_DISTRO_JSON=${BASE_URL}/distro.local.json
  ENV TIPI_DISTRO_JSON_SHA1=${TIPI_DISTRO_JSON_SHA1}
  ENV TIPI_INSTALL_SOURCE=${TIPI_INSTALL_SOURCE}
  ENV TIPI_CLIENT_INSTALL_SCRIPT_SOURCE=${BASE_URL}/$TIPI_CLIENT_INSTALL_SCRIPT_SOURCE_SHA1SUM-$(basename "$TIPI_CLIENT_INSTALL_SCRIPT_SOURCE")
  ENV TIPI_UTIL_LINUX_SOURCES_MIRROR=${BASE_URL}/util-linux-2.39.tar.gz
  ENV TIPI_CONTAINER_INSTALL_SCRIPT=${BASE_URL}/$TIPI_CONTAINER_INSTALL_SCRIPT_SHA1SUM-$(basename "$TIPI_CONTAINER_INSTALL_SCRIPT")

  ARG DEBIAN_FRONTEND=noninteractive # avoid tzdata asking for configuration
  # Install tipi and cmake-re
  RUN curl -fsSL \${TIPI_CONTAINER_INSTALL_SCRIPT} -o cmake-re_container_install.sh && /bin/bash cmake-re_container_install.sh
  USER tipi
  WORKDIR /home/tipi
  EXPOSE 22
"""