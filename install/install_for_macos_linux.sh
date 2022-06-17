#!/bin/bash

# tipi CLI macos & linux installer script
# Copyright 2020 - () tipi technologies Ltd (Zürich)
#
# Environment variables
#
# - TIPI_INSTALL_VERSION:   overrides release to install - must match release tag 
# - TIPI_INSTALL_SOURCE:    override the source path of the release zip
#                           -> a file:// url can be used to install from a locally present zip

###
# Helper functions
###

abort() {
  printf " \e[91m $1 \n"
  exit 1
}

info() {
  printf "\e[1;32m -> \e[0m $1 \n"
}

should_install_unzip() {
  if [[ $(command -v unzip) ]]; then
    return 1
  fi
}

###
# impl.
### 

VERSION="${TIPI_INSTALL_VERSION:-v0.0.31}"
INSTALL_FOLDER=/usr/local

if [[ -z "${TIPI_INSTALL_SOURCE}" ]]; then
  if [ "$(uname)" == "Linux" ]; then
    TIPI_URL="https://github.com/tipi-build/cli/releases/download/$VERSION/tipi-$VERSION-linux-x86_64.zip" 
  elif [ "$(uname)" == "Darwin" ]; then
    TIPI_URL="https://github.com/tipi-build/cli/releases/download/$VERSION/tipi-$VERSION-macOS.zip"
  fi
else
  TIPI_URL="${TIPI_INSTALL_SOURCE}"
fi


if [ -f "/etc/arch-release" ]; then
  pacman -Syu --noconfirm
  pacman -S --needed --noconfirm python
  pacman -S --needed --noconfirm unzip
  pacman -S --needed --noconfirm base-devel
  pacman -S --needed --noconfirm openssh
fi

if should_install_unzip; then
    info "The 'unzip' command is required to extract the downloaded file, we are installing unzip with your package manager"
    echo "Could you validate with your password ? 😇 "
    sudo apt-get install unzip -y || abort "Error while installing unzip"
fi

TMP_DOWNLOAD_PATH=~/tipi-$VERSION.zip

info "Downloading tipi from: $TIPI_URL"
info "Saving archive to: $TMP_DOWNLOAD_PATH"
curl -fSL $TIPI_URL --output $TMP_DOWNLOAD_PATH || wget -q $TIPI_URL -O $TMP_DOWNLOAD_PATH || abort "Could not download tipi"

info "Installing tipi in $INSTALL_FOLDER"
sudo unzip $TMP_DOWNLOAD_PATH -d $INSTALL_FOLDER -x LICENSE

if [ $? -eq 0 ]; then
    tipi_full_path=$INSTALL_FOLDER/bin/tipi
    sudo chown ${USER:=$(/usr/bin/id -run)}:$USER $tipi_full_path
    sudo chmod a+x,u+w $tipi_full_path

    info "Cleaning up temporary download"
    rm $TMP_DOWNLOAD_PATH

    info "Provisioning included tools."
    $INSTALL_FOLDER/bin/tipi -v --dont-upgrade run echo "[INFO] Shipping tools done"
    if [ $? -eq 0 ]; then
        info "tipi has been installed in $INSTALL_FOLDER/bin and can be used now."
        info "----------------------------"
        info "If you are new to tipi you can explore how to use it at: https://tipi.build/explore. If you are currently following the onboarding guide it is now time to get back to your browser: https://tipi.build/onboarding/step4"
    else 
        abort "Error while installing the dependencies"
    fi
else
    abort "Installation failed, please contact us on https://tipi.build : We are happy to help."
fi
