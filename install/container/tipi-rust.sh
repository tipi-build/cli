#!/bin/bash

# tipi-rust docker setup script
# Copyright 2024 - tipi technologies Ltd (Zürich)

# ignore errexit with `&& true`
getopt --test > /dev/null && true
if [[ $? -ne 4 ]]; then
    echo -e '`getopt --test` failed in this environment.'
    exit 1
fi

# option --output/-o requires 1 argument
LONGOPTS=help,group:
OPTIONS=yhg:

# usage function
function usage()
{
   cat << HEREDOC

Usage: $progname [--group GROUP_NAME]

Additionally, this program requires the following environment variables to be defined:

  RUSTUP_TOOLCHAIN            the rust toolchain to install (version / release)
  RUSTUP_HOME                 path to .rustup
  CARGO_HOME                  path to .cargo

optional arguments:
  -h, --help                 show this help message and exit
  -y                         proceed without asking
  -g, --group GROUP_NAME     name of the user group to chgroup the rustup & cargo install folders to for shared installation
    
HEREDOC
}  

# initialize variables
progname=$(basename $0)
cli_arg_group=
cli_arg_yes=

# use getopt and store the output into $OPTS
# note the use of -o for the short options, --long for the long name options
# and a : for any option that takes a parameter
OPTS=$(getopt -o "${OPTIONS}" --long "${LONGOPTS}" -n "$progname" -- "$@")
if [ $? != 0 ] ; then echo "Error in command line arguments." >&2 ; usage; exit 1 ; fi
eval set -- "$OPTS"

while true; do
  # uncomment the next line to see how shift is working
  # echo "\$1:\"$1\" \$2:\"$2\""
  case "$1" in
    -h | --help ) usage; exit; ;;
    -g | --group ) cli_arg_group="$2"; shift 2 ;;
    -y ) cli_arg_yes=-y; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [ -z "${RUSTUP_TOOLCHAIN}" ]; then
    echo -e "[error] RUSTUP_TOOLCHAIN needs to be set to the rust toolchain / release to be installed"
    usage
    exit 1
fi

if [ -z "${RUSTUP_HOME}" ]; then
    echo -e "[error] Please set RUSTUP_HOME"
    usage
    exit 1
fi

if [ -z "${CARGO_HOME}" ]; then
    echo -e "[error] Please set CARGO_HOME"
    usage
    exit 1
fi

# exit on failures
set -e

echo -e "Setting up tipi/rust with"
echo -e " - CARGO_HOME=${CARGO_HOME}"
echo -e " - RUSTUP_HOME=${RUSTUP_HOME}"
echo -e " - RUSTUP_TOOLCHAIN=${RUSTUP_TOOLCHAIN}"

if [ -n "$cli_arg_group" ]; then
    if [ ! $(getent group ${cli_arg_group}) ]; then
        echo "[error] group '${cli_arg_group}' does not exist on this system, aborting"
        exit 1
    fi

    echo -e " - [Multi-user install target group]=$cli_arg_group"
fi

mkdir -p ${CARGO_HOME}
mkdir -p ${RUSTUP_HOME}

echo -e "Installing rust ${RUSTUP_TOOLCHAIN} using rustup from https://sh.rustup.rs"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --default-toolchain ${RUSTUP_TOOLCHAIN} ${cli_arg_yes}

if [ -n "$cli_arg_group" ]; then
    echo -e "Setting access rights in ${CARGO_HOME}"
    chmod --recursive g=u ${CARGO_HOME}
    chgrp --recursive ${cli_arg_group} ${CARGO_HOME}

    echo -e "Setting access rights in ${RUSTUP_HOME}"
    chmod --recursive g=u ${RUSTUP_HOME}
    chgrp --recursive ${cli_arg_group} ${RUSTUP_HOME}
fi

echo -e "[DONE]"