#!/bin/bash

set -e

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

# Enable login with tipi generated ssh-rsa on Ubuntu 22 and onwards, use PubkeyAcceptedKeyTypes vs PubkeyAcceptedAlgorithms as it works on ubuntu 20.04 as well.
mkdir -p /etc/ssh/sshd_config.d/ && \
    printf "\nPubkeyAcceptedKeyTypes +ssh-rsa\n" > /etc/ssh/sshd_config.d/add-ssh-rsa.conf
service ssh start # Create /run/sshd privilege separation directory, the docker CMD should still be something like `/usr/sbin/sshd -D -o ListenAddress=0.0.0.0 -e;`

# User id 1001 is the user on Github Default Runner and 123 is the group of the files on the Github Default Runner
addgroup --gid 123 gh-actions-group
addgroup --gid 124 wine

if [ ! $(getent group 1001) ]; then
  addgroup --gid 1001 tipi
fi
useradd --system --uid 1001 --gid 1001 -G gh-actions-group,wine,sudo --create-home --home-dir /home/tipi tipi \
  && echo 'tipi ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tipi

if [ ! $(getent group 1000) ]; then
  addgroup --gid 1000 tipi-large
fi
useradd --system --uid 1000 --gid 1000 -G gh-actions-group,wine,sudo --create-home --home-dir /home/tipi-large tipi-large \
  && echo 'tipi-large ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tipi-large

if [ ! $(getent group 108) ]; then
  addgroup --gid 108 tipi-rbe
fi
# https://docs.engflow.com/re/client/bazel-first-time.html#1-prepare-a-docker-container-image-for-remote-actions
useradd --system --uid 108 --gid 108 -G gh-actions-group,wine,sudo --create-home --home-dir /home/tipi-rbe tipi-rbe \
  && echo 'tipi-rbe ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tipi-rbe


# Get tipi to store in the right home for gh-action
mkdir -p /usr/local/share/.tipi && chown tipi:tipi -R /usr/local/share/.tipi
mkdir -p /home/tipi/.ssh && chown tipi:tipi -R /home/tipi/.ssh

# http_proxy temp folder for IPC & logging for the additional users
mkdir /run/user/1001 \
 && chown 1001:1001 /run/user/1001 \
 && chmod 0700 /run/user/1001

mkdir /run/user/1000 \
 && chown 1000:1000 /run/user/1000 \
 && chmod 0700 /run/user/1000

mkdir /run/user/108 \
 && chown 108:108 /run/user/108 \
 && chmod 0700 /run/user/108

chsh -s /bin/bash root
chsh -s /bin/bash tipi
chsh -s /bin/bash tipi-large
chsh -s /bin/bash tipi-rbe

# This is required because of docker virtiofs on docker on macOS. ( VirtioFS is not handling permissions as expected. All mount permissions are owned by root regardless of chown : https://github.com/docker/for-mac/issues/6243 )
git config --system --add safe.directory "*"

export TIPI_DISTRO_MODE=${TIPI_DISTRO_MODE:light}
su tipi -w TIPI_INSTALL_SOURCE,TIPI_DISTRO_MODE -c "curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/feature/release-v0.0.72/install/install_for_macos_linux.sh -o install_for_macos_linux.sh && /bin/bash install_for_macos_linux.sh"

rm -rf ./main \
  && rm -rf /usr/local/share/.tipi/downloads/* \
  && rm -rf /usr/local/share/.tipi/v*.d/* \
  && rm -rf /usr/local/share/.tipi/v*.w/*
