#!/bin/bash
# tipi docker setup script for debian and arch derivativees
# Copyright 2024 - tipi technologies Ltd (Zürich)

set -e

# INCLUDE+ common/Dockerfile.apt-install-required
apt-get -y update && apt-get install -y \
  openssh-server \
  sudo \
  curl \
  unzip \
  git \
  xz-utils \
  ca-certificates \
  bzip2 

source /etc/lsb-release
DISTRIB_RELEASE_MAJOR=`echo $DISTRIB_RELEASE | sed 's/\([0-9]\+\)\..*/\1/'`

if [ "$TIPI_INSTALL_LEGACY_PACKAGES" = "ON" ]; then
  #INCLUDE+ common/Dockerfile.apt-install-required
  apt-get -y update && apt-get install -y \
    locales \
    build-essential \
    autotools-dev \
    autoconf \
    m4 \
    libtool \
    gcovr \
    iptables \
    apt-utils \
    pkg-config \
    automake \
    autoconf-archive \
    autopoint \
    flex \
    libcap-dev \
    libssl-dev \
    zlib1g-dev \
    byacc \
    bison \
    freeglut3-dev

  locale-gen "en_US.UTF-8"
fi

# INCLUDE+ common/Dockerfile.apt-install-required-before-2204
if [ ${DISTRIB_RELEASE_MAJOR} -le 20 ]; then
  apt-get -y update && apt-get install -y \
    python 
fi

# INCLUDE+ common/Dockerfile.update-su
if [ ${DISTRIB_RELEASE_MAJOR} -le 16 ]; then
  apt-get -y update && apt-get install -y \
    wget \
    libpam-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*



  wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.tar.gz  \
    && tar xvzf util-linux-2.39.tar.gz  \
    && cd util-linux-2.39/  \
    && ./configure \
    && make su \
    && cd .. \
    && mv util-linux-2.39/su /bin/su \
    && chmod u+s /bin/su \
    && rm -rf util-linux-2.39/ \
    && rm -rf util-linux-2.39.tar.gz 

  # X3 Root CA Certificate Deprecation Bug
  sed -i 's#mozilla/DST_Root_CA_X3.crt#!mozilla/DST_Root_CA_X3.crt#' /etc/ca-certificates.conf && update-ca-certificates
fi

# INCLUDE+ common/Dockerfile.apt-install-required-2204
if [ ${DISTRIB_RELEASE_MAJOR} -ge 20 ]; then
  apt-get -y update && apt-get install -y \
    python3
fi

if [ ${DISTRIB_RELEASE_MAJOR} -ge 24 ]; then
  # Since Ubuntu 24.04 dockers enforce a standard ubuntu user with
  # uid:1000, but current compatibility strategy for the docker with
  # Github Large Runners requires tipi-large user to have uid 1000
  userdel ubuntu
fi


# INCLUDE+ common/Dockerfile.remote-build-ssh-access
# Enable login with tipi generated ssh-rsa on Ubuntu 22 and onwards, use PubkeyAcceptedKeyTypes vs PubkeyAcceptedAlgorithms as it works on ubuntu 20.04 as well.
mkdir -p /etc/ssh/sshd_config.d/ && \
    printf "\nPubkeyAcceptedKeyTypes +ssh-rsa\n" > /etc/ssh/sshd_config.d/add-ssh-rsa.conf
service ssh start # Create /run/sshd privilege separation directory, the docker CMD should still be something like `/usr/sbin/sshd -D -o ListenAddress=0.0.0.0 -e;`

# INCLUDE+ common/Dockerfile.tipi-non-root-user
export SUDO_GROUP=${SUDO_GROUP:-sudo}
echo "Current SUDO_GROUP: ${SUDO_GROUP}"
# User id 1001 is the user on Github Default Runner and 123 is the group of the files on the Github Default Runner
groupadd --gid 123 gh-actions-group
groupadd --gid 124 wine

if [ ! $(getent group 1001) ]; then
  groupadd --gid 1001 tipi
fi
useradd --system --uid 1001 --gid 1001 -G gh-actions-group,wine,${SUDO_GROUP} --create-home --home-dir /home/tipi tipi \
  && echo 'tipi ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tipi

if [ ! $(getent group 1000) ]; then
  groupadd --gid 1000 tipi-large
fi
useradd --system --uid 1000 --gid 1000 -G gh-actions-group,wine,${SUDO_GROUP} --create-home --home-dir /home/tipi-large tipi-large \
  && echo 'tipi-large ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tipi-large

if [ ! $(getent group 108) ]; then
  groupadd --gid 108 tipi-rbe
fi
# https://docs.engflow.com/re/client/bazel-first-time.html#1-prepare-a-docker-container-image-for-remote-actions
useradd --system --uid 108 --gid 108 -G gh-actions-group,wine,${SUDO_GROUP} --create-home --home-dir /home/tipi-rbe tipi-rbe \
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

export TIPI_DISTRO_MODE=${TIPI_DISTRO_MODE:-default}
export TIPI_ENV_WHITELIST=${TIPI_ENV_WHITELIST:-TIPI_INSTALL_SOURCE,TIPI_DISTRO_MODE,TIPI_DISTRO_JSON,TIPI_DISTRO_JSON_SHA1}
# INCLUDE+ common/Dockerfile.rustup
if [ "$TIPI_INSTALL_LEGACY_PACKAGES" = "ON" ]; then
  su tipi -w ${TIPI_ENV_WHITELIST} -c "cd ~ && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup.sh && sh rustup.sh -v -y --no-modify-path"
  su tipi -w ${TIPI_ENV_WHITELIST} -c "/home/tipi/.cargo/bin/rustup default stable"
fi

# INCLUDE+ common/Dockerfile.install-tipi
su tipi -c 'cd ~ && curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/feature/release-v0.0.78/install/install_for_macos_linux.sh -o install_for_macos_linux.sh && /bin/bash install_for_macos_linux.sh'

rm -rf ./main \
  && rm -rf /usr/local/share/.tipi/downloads/* \
  && rm -rf /usr/local/share/.tipi/v*.d/* \
  && rm -rf /usr/local/share/.tipi/v*.w/* \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*