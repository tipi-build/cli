# syntax = edrevo/dockerfile-plus:0.1.0
FROM tipibuild/tipi-ubuntu:just_built AS tipi-ubuntu-base

USER tipi
WORKDIR /home/tipi

# this generates a couple of images
INCLUDE+ common/Dockerfile.msvc-wine-ubuntu2004