#!/usr/bin/env bash
# Test suite for download_distro.sh
# Downloads are intercepted — no real archives are fetched.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT="$SCRIPT_DIR/download_distro.sh"

# ── colour helpers ────────────────────────────────────────────────────────────
red()    { printf '\033[0;31m%s\033[0m\n' "$*"; }
green()  { printf '\033[0;32m%s\033[0m\n' "$*"; }
cyan()   { printf '\033[0;36m%s\033[0m\n' "$*"; }

PASS=0; FAIL=0

assert() {
  local desc="$1"; shift
  if "$@" &>/dev/null; then
    green "  [PASS] $desc"
    (( PASS++ )) || true
  else
    red "  [FAIL] $desc"
    (( FAIL++ )) || true
  fi
}

assert_eq() {
  local desc="$1" expected="$2" actual="$3"
  if [[ "$expected" == "$actual" ]]; then
    green "  [PASS] $desc"
    (( PASS++ )) || true
  else
    red "  [FAIL] $desc"
    red "         expected: $expected"
    red "         actual  : $actual"
    (( FAIL++ )) || true
  fi
}

# ── setup: temp working directory ─────────────────────────────────────────────
WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

# ── mock curl factory ─────────────────────────────────────────────────────────
# Installs a fake curl into a given bin dir.
# The fake curl fetches the real distro.json once; all other downloads are stubs.
setup_mock_curl() {
  local bin_dir="$1"
  mkdir -p "$bin_dir"
  cat > "$bin_dir/curl" <<'MOCK'
#!/usr/bin/env bash
output_file=""
url=""
args=("$@")
i=0
while (( i < ${#args[@]} )); do
  case "${args[$i]}" in
    -o) (( i++ )); output_file="${args[$i]}" ;;
    http*) url="${args[$i]}" ;;
  esac
  (( i++ )) || true
done
REAL_URL="https://raw.githubusercontent.com/tipi-build/distro/refs/heads/main/distro.json"
if [[ "$url" == "$REAL_URL" ]]; then
  /usr/bin/curl -fsSL "$url" -o "$output_file"
else
  touch "$output_file"
fi
MOCK
  chmod +x "$bin_dir/curl"
}

# ── helper: run script in isolated subdir ─────────────────────────────────────
# Usage: run_scenario <label> [KEY=VAL ...]
# After the call, use $WORKDIR/<label> for assertions — nothing is printed to stdout.
run_scenario() {
  local label="$1"; shift   # scenario name
  local subdir="$WORKDIR/$label"
  mkdir -p "$subdir"
  local mock_bin="$subdir/.mockbin"
  setup_mock_curl "$mock_bin"
  (
    export PATH="$mock_bin:$PATH"
    cd "$subdir"
    env "$@" bash "$MAIN_SCRIPT" .
  )
}

# ═══════════════════════════════════════════════════════════════════════════════
# Scenario 1 — mode=default, no platform filter
# ═══════════════════════════════════════════════════════════════════════════════
cyan ""
cyan "══════════════════════════════════════════════════"
cyan " Scenario 1: TIPI_DISTRO_MODE=default (all platforms)"
cyan "══════════════════════════════════════════════════"
run_scenario "s1" TIPI_DISTRO_MODE=default
S1="$WORKDIR/s1"

EXPECTED_TOOLS=(openssh environments ssh-over-http-proxy cmake make ninja cmake-tipi-provider reclient)

cyan "--- assertions ---"

assert "S1: distro.local.json created" test -f "$S1/distro.local.json"
assert "S1: distro.local.json is valid JSON" jq empty "$S1/distro.local.json"

actual_tools=$(jq -r '[.distro[].name] | sort | join(" ")' "$S1/distro.local.json")
expected_sorted=$(printf '%s\n' "${EXPECTED_TOOLS[@]}" | sort | tr '\n' ' ' | sed 's/ $//')
assert_eq "S1: exactly the default-mode tools are present" "$expected_sorted" "$actual_tools"

non_file=$(jq -r '[.distro[].platforms | to_entries[] | .value | to_entries[] | .value.url | select(. != null and (startswith("file://") | not))] | length' "$S1/distro.local.json")
assert_eq "S1: all URLs use file:// scheme" "0" "$non_file"

mode_count=$(jq '.modes | length' "$S1/distro.local.json")
assert_eq "S1: modes stripped to 1 entry" "1" "$mode_count"

# All three platforms should still be present (no platform filter)
cmake_platforms=$(jq -r '.distro[] | select(.name=="cmake") | .platforms | keys | sort | join(" ")' "$S1/distro.local.json")
assert_eq "S1: cmake retains all platforms when no filter" "linux macos windows" "$cmake_platforms"

# "all" platform tools must be present even when no platform filter is set
env_platforms=$(jq -r '.distro[] | select(.name=="environments") | .platforms | keys | join(" ")' "$S1/distro.local.json")
assert_eq "S1: 'all'-platform tool (environments) is present with no platform filter" "all" "$env_platforms"

cmake_tipi_platforms=$(jq -r '.distro[] | select(.name=="cmake-tipi-provider") | .platforms | keys | join(" ")' "$S1/distro.local.json")
assert_eq "S1: 'all'-platform tool (cmake-tipi-provider) is present with no platform filter" "all" "$cmake_tipi_platforms"

for tool in perl python nodejs clang go; do
  count=$(jq --arg t "$tool" '[.distro[].name] | index($t)' "$S1/distro.local.json")
  assert_eq "S1: '$tool' absent (not in default mode)" "null" "$count"
done

# ═══════════════════════════════════════════════════════════════════════════════
# Scenario 2 — mode=default + platform=linux
# ═══════════════════════════════════════════════════════════════════════════════
cyan ""
cyan "══════════════════════════════════════════════════"
cyan " Scenario 2: TIPI_DISTRO_MODE=default + TIPI_DISTRO_PLATFORM=linux"
cyan "══════════════════════════════════════════════════"
run_scenario "s2" TIPI_DISTRO_MODE=default TIPI_DISTRO_PLATFORM=linux
S2="$WORKDIR/s2"

cyan "--- assertions ---"

assert "S2: distro.local.json created" test -f "$S2/distro.local.json"
assert "S2: distro.local.json is valid JSON" jq empty "$S2/distro.local.json"

# Only linux and "all" platforms should appear
bad_platforms=$(jq -r '[
  .distro[].platforms | keys[]
  | select(. != "linux" and . != "all")
] | length' "$S2/distro.local.json")
assert_eq "S2: no macos/windows platform entries remain" "0" "$bad_platforms"

# cmake has linux — must be present
cmake_platforms=$(jq -r '.distro[] | select(.name=="cmake") | .platforms | keys | join(" ")' "$S2/distro.local.json")
assert_eq "S2: cmake keeps only linux platform" "linux" "$cmake_platforms"

# environments has only "all" — must still be present
env_platforms=$(jq -r '.distro[] | select(.name=="environments") | .platforms | keys | join(" ")' "$S2/distro.local.json")
assert_eq "S2: environments keeps 'all' platform" "all" "$env_platforms"

non_file2=$(jq -r '[.distro[].platforms | to_entries[] | .value | to_entries[] | .value.url | select(. != null and (startswith("file://") | not))] | length' "$S2/distro.local.json")
assert_eq "S2: all URLs use file:// scheme" "0" "$non_file2"

# File count matches URL count in the stripped JSON
downloaded=$(ls "$S2/" | wc -l | tr -d ' ')
expected_urls=$(jq -r '[.distro[].platforms | to_entries[] | .value | to_entries[] | .value.url | select(. != null)] | length' "$S2/distro.local.json")
# 4 additional hardcoded files:  install_for_macos_linux.sh, ubuntu.sh/centos.sh, tipi-v0.0.85-linux-x86_64.zip  + distro.local.json
expected_urls=$((expected_urls + 4 ))
assert_eq "S2: downloaded file count matches URL count in distro.local.json" "$expected_urls" "$downloaded"

# ═══════════════════════════════════════════════════════════════════════════════
# Scenario 3 — platform=linux only (no mode filter)
# ═══════════════════════════════════════════════════════════════════════════════
cyan ""
cyan "══════════════════════════════════════════════════"
cyan " Scenario 3: TIPI_DISTRO_PLATFORM=linux (all tools)"
cyan "══════════════════════════════════════════════════"
run_scenario "s3" TIPI_DISTRO_PLATFORM=linux TIPI_DISTRO_MODE=all
S3="$WORKDIR/s3"

cyan "--- assertions ---"

assert "S3: distro.local.json created" test -f "$S3/distro.local.json"
assert "S3: distro.local.json is valid JSON" jq empty "$S3/distro.local.json"

bad_platforms3=$(jq -r '[
  .distro[].platforms | keys[]
  | select(. != "linux" and . != "all")
] | length' "$S3/distro.local.json")
assert_eq "S3: no macos/windows entries in any tool" "0" "$bad_platforms3"

# "all" platform tools must still appear even when platform=linux is set
env_platforms3=$(jq -r '.distro[] | select(.name=="environments") | .platforms | keys | join(" ")' "$S3/distro.local.json")
assert_eq "S3: 'all'-platform tool (environments) is present with platform=linux" "all" "$env_platforms3"

# All tools (not just default mode) should be present
tool_count=$(jq '[.distro[].name] | length' "$S3/distro.local.json")
all_tool_count=$(curl -fsSL "https://raw.githubusercontent.com/tipi-build/distro/refs/heads/main/distro.json" 2>/dev/null | jq '[.distro[].name] | length')
assert_eq "S3: all tools present (no mode filter)" "$all_tool_count" "$tool_count"

# ═══════════════════════════════════════════════════════════════════════════════
# Scenario 4 — arbitrary / unknown platform is accepted
# ═══════════════════════════════════════════════════════════════════════════════
cyan ""
cyan "══════════════════════════════════════════════════"
cyan " Scenario 4: arbitrary platform (freebsd) is accepted"
cyan "══════════════════════════════════════════════════"
run_scenario "s4" TIPI_DISTRO_PLATFORM=arm64
S4="$WORKDIR/s4"

cyan "--- assertions ---"

assert "S4: distro.local.json created"       test -f "$S4/distro.local.json"
assert "S4: distro.local.json is valid JSON" jq empty "$S4/distro.local.json"

# No freebsd-specific entries exist in the real distro.json, so only "all"
# platform tools should remain
bad_platforms4=$(jq -r '[
  .distro[].platforms | keys[]
  | select(. != "freebsd" and . != "all")
] | length' "$S4/distro.local.json")
assert_eq "S4: no entries for other platforms (only freebsd + all)" "0" "$bad_platforms4"

# "all" platform tools must still be present
env_platforms4=$(jq -r '.distro[] | select(.name=="environments") | .platforms | keys | join(" ")' "$S4/distro.local.json")
assert_eq "S4: 'all'-platform tool (environments) present for unknown platform" "all" "$env_platforms4"

# ── summary ───────────────────────────────────────────────────────────────────
echo ""
cyan "══════════════════════════════════════════════════"
cyan " Results: $PASS passed, $FAIL failed"
cyan "══════════════════════════════════════════════════"
echo ""
if (( FAIL > 0 )); then
  red "Some tests failed."
  exit 1
else
  green "All tests passed."
fi
