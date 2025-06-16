ARG UBUNTU_24_04="ubuntu@sha256:04f510bf1f2528604dc2ff46b517dbdbb85c262d62eacc4aa4d3629783036096"
FROM ${UBUNTU_24_04}

ENV TIPI_DISTRO_MODE=default
ENV TIPI_INSTALL_LEGACY_PACKAGES=OFF
ENV TIPI_INSTALL_SOURCE=file:///tipi-linux-x86_64.zip
COPY /tipi-linux-x86_64.zip .

ARG DEBIAN_FRONTEND=noninteractive # avoid tzdata asking for configuration
# Install tipi and cmake-re

RUN apt update -y && apt install -y curl gettext
COPY ubuntu.sh /ubuntu.sh
RUN curl -fsSL file:///ubuntu.sh -o ubuntu.sh && /bin/bash ubuntu.sh
USER tipi
WORKDIR /home/tipi
EXPOSE 22

