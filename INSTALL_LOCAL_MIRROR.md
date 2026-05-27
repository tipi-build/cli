# Providing a self-hosted installation mirror for `cmake-re`
In some context it can be necessary to shield the installation from the internet and use a mirror instead in order to provide a fully 
self-hosted installation from validated sources.

The Install scripts provide customization points and a script is available to make a local copy of all required TIPI_DISTRO_JSON tooling.

In short you will need to 
1. run the distro-downloader tool to create a copy of distro.json that points to your local URLs
2. Set the following variables during the docker build process : 
  * `TIPI_DISTRO_JSON`
  * `TIPI_DISTRO_JSON_SHA1`
  * `TIPI_INSTALL_SOURCE`
  * `TIPI_CLIENT_INSTALL_SCRIPT_SOURCE`
  * `TIPI_UTIL_LINUX_SOURCES_MIRROR`

More details and an example hereafter.

## Note
`TIPI_INSTALL_LEGACY_PACKAGES=ON` is not used in `cmake-re` and won't be supported by self-hosted installation, the LEGACY mode is only used in official tipi 
dockers for backward compatibility reasons and is subject of being removed in the future.

The `install/container/*.sh` containers initialization scripts provide customization points to perform the installation.

## `install/container/centos.sh` customization point 

- You have to configure a local yum mirror in the Docker image before running the script, as we install packages like openssh-server
- `ENV TIPI_CLIENT_INSTALL_SCRIPT_SOURCE` `cmake-re` to override client install script URL (_i.e._ override for https://raw.githubusercontent.com/tipi-build/cli/master/install/install_for_macos_linux.sh)

## `install/container/ubuntu.sh` customization point 
- You have to configure a local apt mirror in the Docker image before running the script, as we install packages like openssh-server
- `ENV TIPI_CLIENT_INSTALL_SCRIPT_SOURCE` `cmake-re` to override client install script URL (_i.e._ override for https://raw.githubusercontent.com/tipi-build/cli/master/install/install_for_macos_linux.sh)
- `ENV UTIL_LINUX_SOURCES_MIRROR` For Ubuntu release 16.04 or older (_i.e_ override for https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.tar.gz)

## cmake-re installation Customization
You will need to provide :
- `ENV TIPI_INSTALL_SOURCE` (_i.e._ override for the cmake-re client binaries release package, override for https://github.com/tipi-build/cli/releases/download/v0.0.86/tipi-v0.0.86-linux-x86_64.zip)

### Local Mirroring of `TIPI_DISTRO_JSON`, `TIPI_DISTRO_JSON_SHA1` 

`cmake-re` requires default tooling to be present, a minimal distro.json should only include updated URLs to : 
- environments
- ssh-over-http-proxy
- cmake
- make
- ninja
- cmake-tipi-provider
- reclient

A locally usable version of TIPI_DISTRO_JSON can be downloaded with all the required tools the `install/utils/distro-downloader/download_distro.sh`, as expained in the next section.

#### Generate a locally mirrored distro

```bash
  install/utils/distro-downloader/download_distro.sh - usage:

  download_distro.sh <OUTPUT-DIR> <BASE_URL>
  
  OUTPUT-DIR
    Where the distro.local.json will be generated and where all distro assets will be downloaded.
  BASE_URL
    Where the distro.local.json should download the distro assets in this network (_i.e. Package mirroring server url)

  Supported Variables:
    TIPI_DISTRO_JSON -  (default: latest from offical cmake-re release)
    TIPI_DISTRO_MODE - (default: "default")
    TIPI_INSTALL_SOURCE - url to release package (default: latest from offical cmake-re release)
    TIPI_CLIENT_INSTALL_SCRIPT_SOURCE - url to client install script (default: latest from offical cmake-re release)
    TIPI_CONTAINER_INSTALL_SCRIPT - url to container install script (default: centos.sh latest from offical cmake-re release)
```

## Working Example: Build a docker from an offline mirror

In order for this build to work, we will locally host the downloaded distro tools at `http://127.0.0.1:8080/tools/` using a lightweigth `httpd`. This URL will be accessible during the docker build phase, so that is what is being passed into the `install/utils/distro-downloader/download_distro.sh` script:

### Setup local mirror
```bash
TOOLS_MIRROR_FOLDER=$PWD/local_tipi_install_mirrror/
# Manually copy our installs script to test the current version
#mkdir -p $TOOLS_MIRROR_FOLDER
#cp -v install/install_for_macos_linux.sh ${TOOLS_MIRROR_FOLDER}
#cp -v install/container/*.sh ${TOOLS_MIRROR_FOLDER}

# Creating a distro.local.json with mirrored archives hosted at http://127.0.0.1:8080/ 
export TIPI_DISTRO_PLATFORM=linux
export PACKAGE_MIRROR_SERVER=http://127.0.0.1:8080/ # Pointing to the httpd local server for demo purposes
install/utils/distro-downloader/download_distro.sh ${TOOLS_MIRROR_FOLDER} ${PACKAGE_MIRROR_SERVER}

# Example mirror to serve the data (this would typically be your internal packages server) start the localhost http server
docker run --name package-mirroring-example-server -d --rm -v ${TOOLS_MIRROR_FOLDER}:/www/ -p 127.0.0.1:8080:80 busybox busybox httpd -f -p 80 -h /www
```

### Build Container
```bash
# build the container
docker build --platform linux/amd64 install/container/environments/linux-offline-almalinux-95.pkr.js/ -f install/container/environments/linux-offline-almalinux-95.pkr.js/linux-offline-almalinux-95.Dockerfile -t linux-offline-almalinux-95:latest --network=host

# stop the server once you're done
docker stop -t0 package-mirroring-example-server
```