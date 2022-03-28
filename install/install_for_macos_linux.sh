#!/bin/bash

VERSION="${TIPI_INSTALL_VERSION:-v0.0.28}"
HOME_DIR="${TIPI_HOME_DIR:-$HOME}"


warning() {
  printf "\e[1;33m ---> $1 \e[0m \n"
}

 if [ "$(uname)" == "Linux" ]; then
    TIPI_URL="https://github.com/tipi-build/cli/releases/download/$VERSION/tipi-$VERSION-linux-x86_64.zip" 
    AVAIABLE_SIZE_FS=$(df -H $HOME_DIR | awk '{ print $4}'  | cut -d'G' -f1 | cut -d'l' -f2 | tr -d '\n' )
    DISTRO_NAME=$(cat /etc/*elease | grep DISTRIB_ID | cut -d '=' -f2)
    DISTRO_VERSION=$(cat /etc/*elease | grep DISTRIB_RELEASE | cut -d '=' -f2 | sed 's@^[^0-9]*\([0-9]\+\).*@\1@')
    if [[ -z "$DISTRO_VERSION" ]] || [[ -z "$DISTRO_NAME" ]] || ( [ "$DISTRO_VERSION" -lt 20 ] && [ "$DISTRO_NAME" != "Ubuntu" ]);then
      warning "tipi is currently supported on Ubuntu 20.04 or later only. You are running an unsuported distribution."
      warning "Do you want to install tipi anyway? (y/n)"
      read answer
      if [ "$answer" == "${answer#[Yy]}" ] ;then 
       exit 1
      fi
    fi
  elif [ "$(uname)" == "Darwin" ]; then
    TIPI_URL="https://github.com/tipi-build/cli/releases/download/$VERSION/tipi-$VERSION-macOS.zip"
    AVAIABLE_SIZE_FS=$(df -g $HOME_DIR |  awk '{ print $4}' | cut -d'e' -f2 | tr -d '\n' )
  fi

abort() {
  printf " \e[91m $1 \n"
  exit 1
}

info() {
  printf "\e[1;32m ---> \e[0m $1 \n"
}

sucess() {
  printf "\e[1;32m ---> $1 \e[0m \n"
}

if [ "$AVAIABLE_SIZE_FS" -le 10 ];then
 warning "You may run out of space as you have only $AVAIABLE_SIZE_FS gb left on your tipi installation drive. A tipi installation typically requires between 2 and 10 gb of disk space depending on installation mode. You may change the installation location by setting the TIPI_HOME_DIR environment variable"
fi

if [ -f "/etc/arch-release" ]; then
  pacman -Syu --noconfirm
  pacman -S --needed --noconfirm python
  pacman -S --needed --noconfirm unzip
  pacman -S --needed --noconfirm base-devel
  pacman -S --needed --noconfirm openssh
fi

should_install_unzip() {
  if [[ $(command -v unzip) ]]; then
    return 1
  fi
}

CURRENT_USER=$(whoami)
SUDO_COMMAND=''
if  command -v sudo &> /dev/null
then
    SUDO_COMMAND='sudo'
fi

if should_install_unzip; then
    info "unzip is needed to unzip the downloaded file, we are installing unzip with your package manager"
    echo "Could you validate with your password ? 😇 "
    $SUDO_COMMAND apt-get install unzip -y || abort "Error while installing unzip"
fi

INSTALL_FOLDER="/usr/local"
info "Downloading tipi..."
curl -fSL $TIPI_URL --output ~/tipi.zip || wget -q $TIPI_URL -O ~/tipi.zip || abort "Could not download tipi"
info "Installing tipi in $INSTALL_FOLDER/bin"
$SUDO_COMMAND unzip ~/tipi.zip -d $INSTALL_FOLDER -x LICENSE && rm ~/tipi.zip

if [ $? -eq 0 ]; then
    info "tipi successfully installed. Installing the dependencies..."
    $SUDO_COMMAND chmod +x $INSTALL_FOLDER/bin/tipi
    $SUDO_COMMAND chown $CURRENT_USER $INSTALL_FOLDER/bin/tipi
    $INSTALL_FOLDER/bin/tipi --help --dont-upgrade
    if [ $? -eq 0 ]; then
        sucess "tipi and its dependencies have been successfully installed"
    else 
        abort "Error while installing the dependencies"
    fi
else
    abort "Installation failed, please contact us on https://tipi.build : We are happy to help."
fi
