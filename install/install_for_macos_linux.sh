#!/bin/bash

if [ "$(uname)" == "Linux" ]; then
  TIPI_URL="https://github.com/tipi-build/cli/releases/download/v0.0.18/tipi-v0.0.18-linux-x86_64.zip"
fi

if [ "$(uname)" == "Darwin" ]; then
  TIPI_URL="https://github.com/tipi-build/cli/releases/download/v0.0.18/tipi-v0.0.18-macOS.zip"
fi

 TIPI_URL_HASH=$(echo -n $TIPI_URL | sha1sum | cut -f 1 -d " ")

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
  pacman -Sy --noconfirm python
  pacman -Sy --noconfirm unzip
  pacman -Sy --noconfirm base-devel
  pacman -Sy --noconfirm openssh
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
    mkdir -p /tmp/$TIPI_URL_HASH/install_tipi && echo "#include <iostream> int main(){return 0;}">> /tmp/$TIPI_URL_HASH/install_tipi/installdeps.cpp
    $INSTALL_FOLDER/bin/tipi /tmp/install_tipi
    if [ $? -eq 0 ]; then
        info "tipi and its dependencies have been successfully installed"
    else 
        abort "Error while installing the dependencies"
    fi
    rm -r /tmp/$TIPI_URL_HASH
else
    abort "Installation failed, please contact us on https://tipi.build : We are happy to help."
fi
