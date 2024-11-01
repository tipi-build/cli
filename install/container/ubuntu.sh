#!/bin/bash

# tipi docker setup script for debian and arch derivativees
# Copyright 2024 - tipi technologies Ltd (Zürich)

apt-get -y update && apt-get install -y \
  openssh-server \
  sudo \
  curl \
  unzip \
  build-essential \
  git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Enable login with tipi generated ssh-rsa on Ubuntu 22 and onwards
printf "\nPubkeyAcceptedAlgorithms +ssh-rsa\n" > /etc/ssh/sshd_config.d/add-ssh-rsa.conf
service ssh start # Create /run/sshd privilege separation directory, the docker CMD should still be something like `/usr/sbin/sshd -D -o ListenAddress=0.0.0.0 -e;`

# User id 1001 is the user on Github Default Runner and 123 is the group of the files on the Github Default Runner
addgroup --gid 123 gh-actions-group
addgroup --gid 124 wine

addgroup --gid 1001 tipi && useradd --system --uid 1001 --gid 1001 -G gh-actions-group,wine,sudo --create-home --home-dir /home/tipi tipi \
  && echo 'tipi ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tipi

addgroup --gid 1000 tipi-large && useradd --system --uid 1000 --gid 1000 -G gh-actions-group,wine,sudo --create-home --home-dir /home/tipi-large tipi-large \
  && echo 'tipi-large ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tipi-large

# https://docs.engflow.com/re/client/bazel-first-time.html#1-prepare-a-docker-container-image-for-remote-actions
addgroup --gid 108 tipi-rbe && useradd --system --uid 108 --gid 108 -G gh-actions-group,wine,sudo --create-home --home-dir /home/tipi-rbe tipi-rbe \
  && echo 'tipi-rbe ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tipi-rbe


# Get tipi to store in the right home for gh-action
mkdir -p /usr/local/share/.tipi && chown tipi:tipi -R /usr/local/share/.tipi
mkdir -p /home/tipi/.ssh && chown tipi:tipi -R /home/tipi/.ssh

# http_proxy temp folder for IPC & logging for the additional users
mkdir /run/user/1001 \
 && chown tipi:tipi /run/user/1001 \
 && chmod 0700 /run/user/1001

mkdir /run/user/1000 \
 && chown tipi-large:tipi-large /run/user/1000 \
 && chmod 0700 /run/user/1000

mkdir /run/user/108 \
 && chown tipi-rbe:tipi-rbe /run/user/108 \
 && chmod 0700 /run/user/108

chsh -s /bin/bash root
chsh -s /bin/bash tipi
chsh -s /bin/bash tipi-large
chsh -s /bin/bash tipi-rbe


export TIPI_DISTRO_MODE=all
su tipi -w TIPI_DISTRO_MODE -c "$(curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/feature/release-v0.0.63/install/install_for_macos_linux.sh)"
su tipi -w TIPI_DISTRO_MODE -c 'cd /home/tipi && mkdir main && echo "int main(){return 0;}" > ./main/main.cpp && /usr/local/bin/tipi --dont-upgrade -v -t linux ./main'

rm -rf ./main \
  && rm -rf /usr/local/share/.tipi/downloads/* \
  && rm -rf /usr/local/share/.tipi/v*.d/* \
  && rm -rf /usr/local/share/.tipi/v*.w/*
