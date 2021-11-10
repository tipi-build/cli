# tipi.build cli : CHANGELOG

## v0.0.23 - codename **original octopus** 🐙

### Bugfix
  - fix windows image creation for tipi-build

tipi-src please complete

##### Archives Checksums
tipi-v0.0.22-windows-win64.zip:please complete
tipi-v0.0.22-linux-x86_64.zip:please complete
tipi-v0.0.22-macOS.zip:please complete

## v0.0.22 - codename **native narwhal** 🐋 + 🦄

### Features
  - HTTP Proxy Support ( e.g. Setting ALL_PROXY or http_proxy variables )
  - Update to CMake 3.21.4
  - CMake Remote Compiler : New options to forward all arguments to CMake 
  - Introduced `--sync-build` to selectively synchronize the build folder

### Bugfix
  - Exclusive use of Port 443 for remote builds

tipi-src 03a4e9433c9b91c6b3813acad9efdaaee0f9fd6f

##### Archives Checksums
tipi-v0.0.22-windows-win64.zip:43CFEBBA6143DA2B035C205AAC99E19984EF4F7A
tipi-v0.0.22-linux-x86_64.zip:FCB40D2A33528243A7B61C9C9CAE373D3D69C8DF
tipi-v0.0.22-macOS.zip:267B4F88386CC720FF73A018692F3F7CE2A383E4

## v0.0.21 - codename **modern magic** ✨

### Features
  - C++20 support
  - Clang v13.0.0

tipi-src 3cd6f370c9980f24e4b1e7bf1325fc2c8ee2cb3e cc3724bb740174b15a8b06b6f9d2db8fbefd8607

##### Archives Checksums
tipi-v0.0.21-windows-win64.zip:2F162CEB41395E1D07B7FD0905D9B39AAE35526F
tipi-v0.0.21-linux-x86_64.zip:B1CCFC0D5EC80972E063E364A9D4439FA5D92DF4
tipi-v0.0.21-macOS.zip:1C3F8F38751E253A13340E41BE80D0C1A141F19C


## v0.0.20 - codename **lucky luc**  

### Bugfix
  - Fix python in the light distro for windows
  - Fix tipi ci template 
  
tipi src 52b3597e66be0d0cc2eaa7f66836d18b644d4129

##### Archives Checksums
tipi-v0.0.20-windows-win64.zip:C405D56D16374CB217A452E876C8D6EE8ECAFAAF
tipi-v0.0.20-linux-x86_64.zip:8728285DC7A54ACB244545E93BB8447BD7BDC45A
tipi-v0.0.20-macOS.zip:663EF18428266F8B23E6BE341535E6F0CEA71D9A


## v0.0.19 - codename **keen kudos** 🥇 

### Features
  - tipi installs a light distro by default now
  - incremental updates to the distro installation
  - remote environment deploy time improved
  - `tipi help` displays the current distro revision

### Bugfix
  - Isolated configuration of tipi shipped SSH client from the system configuration
  - Fixed `tipi.ignore` feature on windows host
  - Fixed forwarding of all build arguments to the remote environment
  - Correct installation of packages on Arch Linux (i.e. the install script doesn't override existing packages)
  - Regressions to run build and remote build on Arch Linux have been fixed
 
tipi src e258d90a666880e6f8edb1bcc0db30d22c4b2199

##### Archives Checksums
tipi-v0.0.19-windows-win64.zip:E33239F36A7F071DC6901754CD0DC69BF1D60F55
tipi-v0.0.19-linux-x86_64.zip:B0D2B5AC5F089BC259EFBA81A85D9D5C3817FFB2
tipi-v0.0.19-macOS.zip:4798B8AFF290EFFBB3861F1DEF9D802200749017


## v0.0.18 - codename **jolly jumper** 🏇

### Features
  - Smart auto include path computation detection to complement convention detection
  - Eclipse project support with remote tipi build
  - Local & remote Monorepo dependencies support
  - Remote git subfolder dependencies support 

### Bugfix
  - Running commands in tipi environment with `tipi run command` on unixes support multiple arguments ( not only a string)
  - Windows TLS environments supports downloading Platform libs from server with recent ciphersuites

tipi src 04004311e7222447601b1f1aacfac84eff995049

##### Archives Checksums
tipi-v0.0.18-linux-x86_64.zip:675EA708D860C08F819732BE8D755D0E2C3AF5FB
tipi-v0.0.18-macOS.zip:894A8BD104DB01DDD141C2F258EEB919B98F839D
tipi-v0.0.18-windows-win64.zip:A2853892D10B83F131578C11B46FEE51195B70CD

  
## v0.0.17 - codename **intrepid increment**

### Features
  - Arch linux support (file-sync daemon and install script updated)
  - Support to clean connection files with `tipi connect --clean`

### Bugfix
  - Fixed numerous remote build issue via a safe command escape system based on base64
  - Fixed remote build from host linux to target linux
  - Fixed remote build from host windows to target windows 
  - Fixed remote build from host windows to target linux 
  - Fixed remote build from host linux to target windows
  - Fixed windows console presentation during remote builds
  - Fixed windows console animations
  - Documentation link fix regarding authentication
  - Fixes C & C++ autocompletion in vscode due to space in target compile\_command path

### Known Issues
  - tipi can be used only on one project at a time
  - visual studio vs- targets ( e.g. vs-16-2019-win64-cxx17 ) targets aren't supported in remote build mode
  - windows remote builds still have a small issue when it comes to tls download from CMake

tipi cli : 0229254d5627956d4aaf65df813e3c191fe5973c eda26ee303b601e6dfd954b837495fdf56fb43b6

##### Archives Checksums
tipi-v0.0.17-linux-x86_64.zip:A7AC809E4B69B558FBCD608E4EE3CFA4709C1411
tipi-v0.0.17-macOS.zip:692F5722939EA277EF51A6142B06692622FA3879
tipi-v0.0.17-windows-win64.zip:C37D649D4F328773FDC1B38505BD70951ACAE5C8

## v0.0.16  - codename **heavy hammer** 🔨

### Features
  - Local machine and Cloud build node project files synchronization  (sources and build)
  - remote build environment creation with Packer declarative images definitions 
  - remote build on tipi.build cloud 
  - remote connectivity to tipi.build nodes to .run tests
  - clang 12 provided for windows, linux and macOS
  - Automatic authentication token refreshing
  - vault synchronization on each connection
  - Vault protected storage server access data


### Bugfix
  - authentication issues points to correct documentation
  - automatic token refreshing on any remote call 

### Known Issues
  - tipi can be used only on one project at a time ( interprocess locks led to deadlock situations )

tipi cli : 88e3506018647c64ef686d9c4004f31a1f1126dc

##### Archives Checksums
tipi-v0.0.16-linux-x86_64.zip:5B0D0493EFC689E41153B8EE27DC1C892CBF2DB0
tipi-v0.0.16-macOS.zip:684FB45325DD8F5052EF7467EAE8A46C4B3205D5
tipi-v0.0.16-windows-win64.zip:67DB580E92D8C13277C0A5C5A68BDF05D77C147C

## v0.0.15 - codename **git gud**  

### Features
  - tipi.build authentication
  - tipi.build secure vault synchronization ( supporting Github.com and Github Enterprise authentication )
  - New toolchains to target asm.js ( Provides compatibility for Webassembly builds on all browsers )
  - Node.js included now directly within the `tipi-build/tipi-ubunt` docker 
  - Java JDK provisioning in the tipi.build distro
  - REST OpenAPI generator integration
  - Force build with CMake and package/targets name in depspec ( e.g. `{ "tipi/libgit2" : { "@" : "v1.1.0-cmake-findpackage", "u" : true, "packages": ["libgit2"], "targets": ["libgit2::git2"]  } }`
  - `.tipiignore` files behaving like `.gitignore` to exclude files from code scan and build. Rules can be passed via the command line `-x` switch too. 

### Bug fixes
  - URL download error fixes to download from proper Boost releases server

## v0.0.14 - codename **fast forward**

### Features
  - Emsdk 2.0.15 with full c++ exceptions support for Webassembly 

### Bug fixes
  - Support parallel use of nxxm software with inteprocess locking capabilities
  - Fix emsdk initialization and installation to a fixed defined version
  - Fixes to enable libgit2 to be built by nxxm

nxxm: 6c18d33ed1b07db36f93e52d177b794e28de10cf 

##### Archives Checksums
nxxm-v0.0.14-linux-x86_64.zip:4D6F857AB5D62EA2D8C0EAD0A436079E694C8EC9
nxxm-v0.0.14-macOS.zip:503C5236F2556069660E7E4C5AAD6D75EBC35A47
nxxm-v0.0.14-windows-win64.zip:58C951CC59A53962EB0388FBE0E81CDB9F07F7FF

## v0.0.13 - codename **embedded embarrassment** 💉

### Bug fixes
  - Fix installation of the emsdk / emscripten compiler since changes in the emsdk installation scheme.

nxxm: 468e7d57d2ec568b2e5153a54df00d3811b67159

##### Archives Checksums
nxxm-v0.0.13-linux-x86_64.zip:ECA92ADF1ED739EB45FB52C784BA542BA0FEEDC9
nxxm-v0.0.13-macOS.zip:73E6D5B642A56E1F8946798451F0A9FE887C2178
nxxm-v0.0.13-windows-win64.zip:65873C89451305C57D26CD21B2BAF04923A845F1


## v0.0.12 - codename **delicious dilution** 🍸

### Features
  - Clang v11.0.0 for windows, linux & macOS with libc++ for host native development included. No additional installation required.
  - nxxm distributions ( compilers and controlled environment ) are managed via a distro.json file, that can be user-overriden ( i.e. with `NXXM_DISTRO_JSON` ).
  - Go is included within the nxxm distribution
  - Official nxxm Docker image for CI is now based on Ubuntu 20.04 LTS

### Bug fixes
  - Fix autocompletion in VSCode when .vscode folder is inexistant
  - VSCode nxxm console supports keyboard inputs & colors during compilation 
  - Parallel build could use an infinite count of jobs when not specifying `-j,--jobs`

### Known issues 
  - On windows with Clang an OpenSSL replacement is provided because of OpenSSL limitations: BoringSSL which is 1:1 API compatible and maintained by Google and the nxxm core team.

nxxm: a17dff230a32f083135f223b51a314e2e525d17e

##### Archives Checksums
nxxm-v0.0.12-linux-x86_64.zip:B77413F9DB8734114DCD8ECAC4F5754C8311FB51
nxxm-v0.0.12-macOS.zip:60F3DEADB4D3249344787959231A47BB16067C35
nxxm-v0.0.12-windows-win64.zip:73DB9B120354A4E9CAD3D872E8EA560EFED6B5ED


## v0.0.11 - codename **christmas cactus** 🎄🌵

### Features
  - [nxxm.io vscode plugin](https://marketplace.visualstudio.com/items?itemName=nxxm.nxxm) initial release !
  - Support for proper autocompletion in Visual Studio by generating `c_cpp_properties.json`

### Bug fixes
  - Internal nxxm.io commands are correctly processed in presence of folders or file of the same name
  - macOS nxxm upgrades are properly done with the nxxm.io vscode plugin

##### Archives Checksums
nxxm-v0.0.11-linux-x86_64.zip:62B85CC0E76DE4D9FBE83076BF9041882AD9B6EE
nxxm-v0.0.11-macOS.zip:4B72585CF72A1C7A33DFB5FB4BCA93A99A94A86B
nxxm-v0.0.11-windows-win64.zip:28497FE24949BAB0BB44E1CE87B1E9C4C940FFA4

## v0.0.10 - codename **far west hotfix**

### Bug fixes
  - Compiling a project by providing a relative path to it : `nxxm relative/path/to-project` now works. 
  - Compiling a project that is stored in a Path where a folder has a space in the name is fixed. ( project folder with spaces don't ).

  
##### Archives Checksums
nxxm-v0.0.10-linux-x86_64.zip:6637A831EEC8997AC46121BF9A00C75B60422F48
nxxm-v0.0.10-macOS.zip:77B49BB0D6A2596BF8C71DA8994D0025FA06A465
nxxm-v0.0.10-windows-win64.zip:53F7FACEBBF8270D8640D42E867B5BAF264436BE

## v0.0.9 - codename **far west** 

### Features
  * `nxxm ci` automatically generates a docker enabled Github Action to build C & C++ code
  * Configurable Build engines via `build_engines_mapping.json`
  * Simplified the nxxm installation process thanks to the one liner install scripts now available
  * Support for macOS Big Sur
  * Default NodeJS included is 14.7.0
  * Default CMake included is 3.18.4
  * Possibility to specify `NXXM_HOME_DIR` on the environment, to specify the main nxxm download and build cache location ( _c.f._  [NXXM\_HOME\_DIR Documentation](https://nxxm-docs.readthedocs.io/en/latest/09-Dependencies_nxxm.html)
  * Build with Visual Studio 16 2019 MSVC via `nxxm . -t vs-16-2019-win64-cxx17`

### Bug fixes
  * Perl is now shipped by nxxm on Windows to accomodate special build processes including OpenSSL
  * Now multiple .cpp files at the top-level folder of an application project ( one with a main() and others without function) work.
  * Fixed build recipe generation for projects in different directories that current nxxm working directory
  * Fix host & cross compiling Boost on Windows
  * Now after 5 downloads retries, nxxm refuses to continue if the SHA1 checksum isn't correct. Precedent version would use the incorrect file.
  * Command line flags `--dont-upgrade, --force-upgrade, --auto-upgrade` can now be passed without any complaints from the options parser, to control nxxm auto-update feature.
  * Improved drastically the test suite to handle build corner cases found at our customers

### Known issues
  - Compiling a project by providing a relative path to it : `nxxm relative/path/to-project` doesn't work. `nxxm .` inside the folder of the project works. 
  - Compiling a project that is stored in a Path where a folder has a space in the name  doesn't work

##### Archives Checksums
nxxm-v0.0.9-linux-x86_64.zip:FE64B5D4DC96FA39BAA97659FAF6CB8F5C25031A
nxxm-v0.0.9-macOS.zip:91A47E79132B173CF2BB176A4E6693FAC8B48FCA
nxxm-v0.0.9-windows-win64.zip:308252401C2467F850611C9336782F5E28215EA1

## ALPHA2 v0.0.8 - codename **prairial** brings Webassembly multithreading and fixes for reported bugs

### Features
* Webassembly builds with wasm threads, emscripten 1.39.5 & NodeJS v14.2.0
* Smart parallel build based on available CPU and RAM when `-j` not specified
* HTML5 embedded C++ code is now better debuggable as column and line positions of compile errors are exactly reported 
* CMake upgraded to version 3.17.2
* Platform libraries to the latest version ( e.g. Boost 1.73.0, Poco 1.10.1, Qt 5.11.3... )
* Proper isolation of $HOME/.nxxm files in corresponding nxxm distro ( Now .nxxm/0000001 )
* Better isolation from host system, only additional tools can be found by nxxm, but library, header and module search never escapes the nxxm builds
* Command line parameter parsing relaxed and meaningful errors
* In verbose mode the spinner widget for long-lasting operation is hidden to generate only useful log informations.

### Bug fixes
* Fix emsdk install error on macOS due to python errors on systems that doesn't have python 3 certificate installed
* Webassembly test runs all now with webassembly threads enabled
* Now -DEFINE passed on the command line doesn't prevent further options to be taken in account
* nxxm now closes correctly after timeout SSL connections that don't gracefully close
* disabled macOS ask for Java installation anymore in webassembly build mode
* better information when accessing private repositories

Welcome to our new contributors that joined during this release Luc [Lambourl](https://github.com/Lambourl) and Marouane [amri04](https://github.com/amri04) !

##### Archives Checksums
nxxm-v0.0.8-linux-x86_64.zip:3F3740B23BE420F1E0584C2A17022675B27A4D75
nxxm-v0.0.8-macOS.zip:C51C4CCA5CBC81E5557AABC4810196F68EE600FA
nxxm-v0.0.8-windows-win64.zip:BAA62065950690F415D62FC9F51A8912DD9AC211



## v0.0.7
* Build by convention by default &amp; Ignores CMakeLists.txt by default unless `-u, --use-cmakelists` or `{ "u" : true }` (or use-cmake.nxxm file is present) is specified on the command line or in `.nxxm/deps`.
* Adds the possibility to only build one of the executable in directory : `-o, --only <executable>` 
* Adds the possibility to select the build type : `-C, --config <MinSizeRel,Release,RelWithDebInfo,Debug>` which enables optimizations or debug symbols accordingly.
* Fix passing apps return code when run with `--test all, appname`
* Fix detection of main function in modern style and more generally with different types and argument count. (See https://github.com/nxxm/nxxm/issues/2) 
* Fix running on plain-vanilla Ubuntu 16.04 (that don't have C++17 libstdc++)

##### Archives Checksums
nxxm-v0.0.7-linux-x86_64.zip:A40147E4AC4659398CB5934D45282D094AC2C34B
nxxm-v0.0.7-macOS.zip:C0277D7FFF02E5FA3827EA421A38B652202BA7F4
nxxm-v0.0.7-windows-win64.zip:82CEF705A968B7633A96AA1250B7C8964E62CD0F


## v0.0.6
* minor bugfix release regarding upgrd code

## v0.0.5
* Initial open release 🎁 🎉 



