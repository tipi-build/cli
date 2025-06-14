#!/bin/bash

# tipi docker setup script for centos
# Copyright 2024 - tipi technologies Ltd (Zürich)

export SSL_CERT_FILE=/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem

yum makecache \
 && yum install -y libnsl sudo ca-certificates openssh-server openssh-clients util-linux-ng util-linux-user libuser python3 cmake3 \
 && yum groupinstall -y 'Development Tools' \
 && yum install -y perl-core perl-IPC-Cmd # OpenSSL 3 build system requires this

trust dump --filter "pkcs11:id=%c4%a7%b1%a4%7b%2c%71%fa%db%e1%4b%90%75%ff%c4%15%60%85%89%10" | openssl x509 | sudo tee /etc/pki/ca-trust/source/blacklist/DST-Root-CA-X3.pem
update-ca-trust extract
# Remove it, when https://github.com/nxxm/nxxm-src/pull/1261 is released
cp /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem /etc/ssl/cert.pem
cp /etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt /etc/ssl/certs/ca-certificates.crt

# Enable ssh
ssh-keygen -A
systemctl enable sshd
rm /run/nologin # allow non root users to login

# User id 1001 is the user on Github Default Runner and 123 is the group of the files on the Github Default Runner
groupadd --gid 123 gh-actions-group
groupadd --gid 124 wine

groupadd --gid 1001 tipi && adduser --system --uid 1001 --gid 1001 -G gh-actions-group,wine,wheel --create-home --home-dir /home/tipi tipi \
  && echo 'tipi ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tipi

groupadd --gid 1000 tipi-large && adduser --system --uid 1000 --gid 1000 -G gh-actions-group,wine,wheel --create-home --home-dir /home/tipi-large tipi-large \
  && echo 'tipi-large ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tipi-large

# https://docs.engflow.com/re/client/bazel-first-time.html#1-prepare-a-docker-container-image-for-remote-actions
groupadd --gid 108 tipi-rbe && adduser --system --uid 108 --gid 108 -G gh-actions-group,wine,wheel --create-home --home-dir /home/tipi-rbe tipi-rbe \
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

 RUN mkdir /run/user/108 \
 && chown tipi-rbe:tipi-rbe /run/user/108 \
 && chmod 0700 /run/user/108

chsh -s /bin/bash root
chsh -s /bin/bash tipi
chsh -s /bin/bash tipi-large
chsh -s /bin/bash tipi-rbe

echo "export SSL_CERT_FILE=/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem" >> /home/tipi/.bashrc
echo "export SSL_CERT_FILE=/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem" >>/home/tipi-large/.bashrc
echo "export SSL_CERT_FILE=/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem" >> /home/tipi-rbe/.bashrc
echo "export SSL_CERT_FILE=/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem" >> /root/.bashrc

# This is required because of docker virtiofs on docker on macOS. ( VirtioFS is not handling permissions as expected. All mount permissions are owned by root regardless of chown : https://github.com/docker/for-mac/issues/6243 )
git config --system --add safe.directory "*"

export TIPI_DISTRO_MODE=all
su tipi -c "$(curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/feature/release-v0.0.72/install/install_for_macos_linux.sh)"
su tipi -c 'cd /home/tipi && mkdir main && echo "int main(){return 0;}" > ./main/main.cpp && /usr/local/bin/tipi --dont-upgrade -v -t linux ./main'

rm -rf ./main \
  && rm -rf /usr/local/share/.tipi/downloads/* \
  && rm -rf /usr/local/share/.tipi/v*.d/* \
  && rm -rf /usr/local/share/.tipi/v*.w/*