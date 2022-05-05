# tipi.build cli : CHANGELOG

## v0.0.30 - codename **transcendent tayen** 🌑
 ## Bugfix
   - `tipi connect` on windows with number separator settings properly working again 

tipi-src  2f80b4df7ca7c50249788ff726363f798ec0f4b9

##### Archives Checksums
tipi-v0.0.30-windows-win64.zip:4479DE2902B3511A91F2EFE764917F7FC8A23B08
tipi-v0.0.30-linux-x86_64.zip:9F930E1D4B13098C99B9F6E971C1ED741EDE4DC5
tipi-v0.0.30-macOS.zip:D34C28E52E21DEEF7C967DD1C0FD48B2E13F161D

## v0.0.29 - codename **systematic squirrel** 🐿️
## Features
  - added the ability to configure your project in the deps file 
## Bugfix
  - user's timezone does not influence the hash of the environment zip 
  - it's now possible to override default ignore rule with target specific .tipiignore.

tipi-src d17a788b73b2ea3058ef312571011b8b78f3eeae

##### Archives Checksums
tipi-v0.0.29-windows-win64.zip:8CD21044CF8DECE30DEFBE7D2FBFED767E33373E
tipi-v0.0.29-linux-x86_64.zip:7B1A073E6F10AF9EF44453E87AC8C3AED1D219EB
tipi-v0.0.29-macOS.zip:084B4A0F7D2D7A915C35B03E30C50FBA8913A5F1

## v0.0.28 - hotfix - codename **rapid roadrunner** a.k.a meep meep 🐦

## Bugfix
  - fix live build on local + remote windows ( related to project with many changes ).
  - first pass include source scanner handles comments better now
  - first pass include source scanner relative inclusions more robust

tipi-src 0260722f7648f4587984564614d161fe02f430b3

##### Archives Checksums
tipi-v0.0.28-windows-win64.zip:E1687153C6DAD628EE6D266A4AE796BC67C369A9
tipi-v0.0.28-linux-x86_64.zip:B7382003C1FD59F77E41E00AE7FE9FB98A91D8B1
tipi-v0.0.28-macOS.zip:744CC91CDEB1FD7EF38A230937E2D248EC3C7746


## v0.0.27 - codename **rapid roadrunner** a.k.a meep meep 🐦

## Bugfix
  - Building on windows remote environment works again
  - Remote monitored live build with tests enabled works as expected

## Know issues
  - Local live build with monitor on windows seems to have some issues on some windows setup ( related to project with many dependencies ).

tipi-src 73df8fd03f210721c1b82ff7512775c263c9491e

##### Archives Checksums
tipi-v0.0.27-windows-win64.zip:06F6885262E21A22655630621224B60C8E408619
tipi-v0.0.27-linux-x86_64.zip:C01EDE5FF2B2525F25B54DA74DA0E652EEB78EE3
tipi-v0.0.27-macOS.zip:3ADC81369A2CCFAF472801AE6669E2ACF04886E7


## v0.0.26 - codename **rapid roadrunner** a.k.a meep meep 🐦
## Features
  - :new: **Live build**: automatically build your changes as you type and save, both watching your remote and local builds + running unit tests
    * `tipi . --monitor`
    * `tipi . --monitor --test all`
  - :zap: **15x faster file sync** for remote builds

## Bugfix
  - tipi doesn't create any empty .git folder anymore ( i.e. instead a build/.tipistore )
  - Building from local windows on remote windows doesn't fail on path issues
  - Using multiple authentication data for the same endpoint ( e.g. combinining multiple Github.com accounts ) is now possible
  - Locales enforced to sane default when not set on the system (fix remote build crashes)
  - C and C++ entrypoints with duplicate names are handled correctly now
  - Multiline main function signatures are now correclty detected as app entrypoints
  - Passphrases for the vault with spaces characters are now supported
  - Introduction of env:TIPI_UPGRADE_REMOTE to ensure remote tipi isn't upgraded unless wanted
  - Small warning if the build/ location is already used by another file


tipi-src 1b18ea8ff9c69c80eb4bc53d79adecd2490bed8b

##### Archives Checksums
tipi-v0.0.26-windows-win64.zip:BAAAEB7A3B1D0892C51CAAADA5799E58BCBF8FE6
tipi-v0.0.26-linux-x86_64.zip:37424C23BFF36E803B60341F2CB5572FB31FF933
tipi-v0.0.26-macOS.zip:AF3C32C9F361A1C9F8CDB527393AF9B1FAE85F10

## v0.0.25 - codename **quantum quality** 💫

## Bugfix
  - Fixed no build folder synchronization by default.
  - Fixed almost-infinite waiting on synchronization after build.

##### Archives Checksums
tipi-v0.0.25-windows-win64.zip:95DCA10764447139FAF5AA0AA3B477A1AE3CF004
tipi-v0.0.25-linux-x86_64.zip:FE1CFC2A28EE8A582EDC9FED0FF252E6D8912193
tipi-v0.0.25-macOS.zip:197234EB0A09AB73712519C68C679B83878DFAAB

## v0.0.24 - codename **playful pony** 🐴

### Bugfix
  - fix the compilation of a program in the docker tipibuild/tipi-ubuntu

tipi-src 820397fd1b99453d3e614a6e3899653bf573541e

##### Archives Checksums
tipi-v0.0.24-windows-win64.zip:89EDF18524EE5B9DADF0A096F3F7CA7BB945F18F
tipi-v0.0.24-linux-x86_64.zip:52461AF25B3D1049142080A7757E7B9889BB3474
tipi-v0.0.24-macOS.zip:2DA01D657591A3A221E49301E89931BF4893C620

## v0.0.23 - codename **outstanding octopus** 🐙

### Bugfix
  - fix windows image creation for tipi-build

tipi-src e09ac83a6426a7ec37b18d3f88fcd26483eda372 

##### Archives Checksums
tipi-v0.0.23-windows-win64.zip:5A07D53877382DACF69AE432EEECE3C9F10D0CBA
tipi-v0.0.23-linux-x86_64.zip:882B66490C484AD174D6873D3ED8477E4FF684B9
tipi-v0.0.23-macOS.zip:95FEDC71B7324C3A23CE5797CB0B4347B5DA6A03

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

tipi-src: 8aeda733ecb57cb647087e48a3577f95ea40e0bb

##### Archives Checksums
tipi-v0.0.15-linux-x86_64.zip:8A1E24E073F34743907BFC269E6C95C9C05D1237
tipi-v0.0.15-macOS.zip:F59233F9B9CFF3E3AF9F636169C995C53583EDF2
tipi-v0.0.15-windows-win64.zip:90E555E0481D1C55F55503CC6B9599A20D00289C

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



