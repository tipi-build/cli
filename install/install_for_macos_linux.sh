#!/bin/bash

if [ "$(uname)" == "Linux" ]; then
  TIPI_URL="https://github.com/tipi-build/cli/releases/download/v0.0.23/tipi-v0.0.23-linux-x86_64.zip"
fi

if [ "$(uname)" == "Darwin" ]; then
  TIPI_URL="https://github.com/tipi-build/cli/releases/download/v0.0.23/tipi-v0.0.23-macOS.zip"
fi


INSTALL_FOLDER="/usr/local"

abort() {
  printf " \e[91m $1 \n"
  exit 1
}

info() {
  printf "\e[1;32m ---> \e[0m $1 \n"
}

should_install_unzip() {
  if [[ $(command -v unzip) ]]; then
    return 1
  fi
}

if [ -f "/etc/arch-release" ]; then
  pacman -Syu --noconfirm
  pacman -S --needed --noconfirm python
  pacman -S --needed --noconfirm unzip
  pacman -S --needed --noconfirm base-devel
  pacman -S --needed --noconfirm openssh
fi


if should_install_unzip; then
    info "unzip is needed to unzip the downloaded file, we are installing unzip with your package manager"
    echo "Could you validate with your password ? 😇 "
    sudo apt-get install unzip -y || abort "Error while installing unzip"
fi

info "Downloading tipi..."
curl -fSL $TIPI_URL --output ~/tipi.zip || wget -q $TIPI_URL -O ~/tipi.zip || abort "Could not download tipi"
info "Installing tipi in $INSTALL_FOLDER/bin"
sudo unzip ~/tipi.zip -d $INSTALL_FOLDER -x LICENSE && rm ~/tipi.zip

if [ $? -eq 0 ]; then
    info "tipi successfully installed. Installing the dependencies..."
    sudo chmod +x $INSTALL_FOLDER/bin/tipi
    $INSTALL_FOLDER/bin/tipi --help
    if [ $? -eq 0 ]; then
        info "tipi and its dependencies have been successfully installed"
    else 
        abort "Error while installing the dependencies"
    fi
else
    abort "Installation failed, please contact us on https://tipi.build : We are happy to help."
fi
