#!/bin/bash
UBUNTU_VERSION="23"
if [[ -n "$UBUNTU_VERSION" ]] && [ "$UBUNTU_VERSION" -lt 20 ] ; then
  echo luc
fi