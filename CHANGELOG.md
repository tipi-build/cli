# tipi.build cli : CHANGELOG

## v0.0.57 -  Tropical Toucan 🌴🐦

### Features

- 🚀 faster and generally improved source synchronization mechanism
  - single deterministic location source mirror per machine/node (instead of up-to 3)
  - now using a highly parallelized data transfer mechanism
  - robust handling of submodules (especially in case of nested submodules)
  - efficient mirroring of uncommitted changes in user workspace
- 🔥 improved protocol efficiency in remote builds
  - `--monitor` mode builds with more immediate feedback and better state control
  - Improved cancellation of remote builds when exiting a running build
  - More efficient secure channel handling
- 🆕 **(beta)** Use `--wait-build-queue` in remote builds on the CI in order to share tipi remote jobs without interfering

### Bug Fixes

- fixed a variety of issues in the child process handling resulting in leaked processes
- (temporarily) disabled remote output rewriting to reduce buffering related output lag
- fixed bug resulting in `--sync-build` downloading irrelevant data (effectively halving transfer time)
- fixed issues in cross-platform path lookups on remote nodes in `tipi build ... --sync-build` and `tipi download` commands
- fixed issues with project subfolder builds

#### Archives Checksums

tipi-v0.0.57-windows-win64.zip:9BE36BD2CE33EF7B41051482B8D931A02EA63BAF
tipi-v0.0.57-linux-x86_64.zip:7A35436D4A943909176258A087896ACA6E1940CF
tipi-v0.0.57-macOS.zip:53F9B9C0C8B81F6C0E7ECDC7A8CF0A10E51B1DAC


## v0.0.56 -  Snowy Salamander ❄️🦎

### Features
- 🚀 Build caching parallelized, happening even on partly failed configure or compile enabling faster collaboration
- Dependencies `installed/` folders are now listed under `build/dependencies` to simplify packaging of runtime dependencies ( e.g. dependencies dynamic libraries )
- Manual `tipi restore` command now restores full dependency trees recursively
- Monitor mode cleans the terminal between compilations and only show current compilation output.

### Bug Fixes
- [`cmake-tipi-provider`](https://github.com/tipi-build/cmake-tipi-provider) :
  - SBOM generation isn't mandatory anymore if the user only wants `FetchContent` caching
  - `$ENV{CURRENT_TIPI_BINARY}` always contains the valid full path to the tipi binary
- Fixes tipi-build/cli#75 [tipi . -t linux-cxx17 --test all runs non-test executables]( https://github.com/tipi-build/cli/issues/75 )

tipi-src: 6a7f8c84083f69f9400df003217b70c0e6066484

##### Archives Checksums

tipi-v0.0.56-windows-win64.zip:7904EE8BF3C3D3BF16646ACA63F77B0E626997EC
tipi-v0.0.56-linux-x86_64.zip:14A8347A3E919CCC8FE20C71632F7D2B7EDF6CE9
tipi-v0.0.56-macOS.zip:A379D622BC1FA564609E98ED7F7A6612B387C0C4


## v0.0.55 - Rocket Rabbit 🚀🐇

### Features
  * :new: [tipi build cache for native CMake FetchContent](https://github.com/tipi-build/cmake-tipi-provider)
  * Introduction of the cache `restore` command that restores the build or install cache entry with a source URI and revision `tipi -t linux restore https://github.com/catchorg/Catch2.git 766541d12d64845f5232a1ce4e34a85e83506b09`
  * `--install` switch to populate the install cache on new builds ( previously only done for dependencies )
  * `.tipi/id` won't be generated anymore as in dependencies builds ( if available it is read )
  * An environment variable CURRENT_TIPI_BINARY is set so that underlying cmake scripts can refer to the tipi currently running the build

tipi-src: ad20968cddcf5b83e2be4438a3ac97033c74e9f6

##### Archives Checksums

tipi-v0.0.55-windows-win64.zip:225F2A71CF6822DFF16D4BC6CB5AC633A6576ACC
tipi-v0.0.55-linux-x86_64.zip:AD47F4FD482E52C50125A0CE3EDEB09BF68E010C
tipi-v0.0.55-macOS.zip:9C36C7AB885327607D146D3340CA5554F2F79627

## v0.0.54 - Quality Quetzal 🦜

### Features

- Optimization for submodules heavy projects : 
  - paralelization of submodule source tree mirroring
  - fine granular submodules files mirroring
- :new:`.tipi/build-cache-extra-locations` to cache additional folders in the build cache thar aren't in the CMAKE_BINARY_DIR

tipi-src: 44b29e7078501825630acfa8f5c182a4ab72aec0

##### Archives Checksums

tipi-v0.0.54-windows-win64.zip:14378D40BE0CBAC8B1F8AF7D8A74C46889D80271
tipi-v0.0.54-linux-x86_64.zip:1B9EF7122A9AEEE8FC390036BCBEFD4EC59AA91D
tipi-v0.0.54-macOS.zip:7CD63BAA21F1933993E59E81D676727D7D5BADFE


## v0.0.53 - Prolific Pronghorn 🐐

### Bug Fixes

- fixed handling of submodule that have partial name collisions 

tipi-src:61fbf431fc07604a86faa362a6a56aa4934ebcc6

##### Archives Checksums

tipi-v0.0.53-windows-win64.zip:9902A0DCA49AB1F2479A7D9E65C6C7E4148DF356
tipi-v0.0.53-linux-x86_64.zip:BC9585C24511395FCA9F8EAE44C54B312B6C62D1
tipi-v0.0.53-macOS.zip:A69A35E7B06FBCFC4020BA659860DE8DF065DF2C

## v0.0.52 - Obliging Ocelot 🐆

### Bug Fixes

- ✨Support for `ninja` on remote `ubuntu 16.04` machines
- Fixing remote execution environment configuration issue on `ubuntu 16.04` targets

tipi-src:d0cb24feb8e065e7b8138c60ac40a9cedae8e248

##### Archives Checksums

tipi-v0.0.52-windows-win64.zip:3E82559D63F8A30A55B89C34AB91FE8092EAC93F
tipi-v0.0.52-linux-x86_64.zip:4B0C9004D72BDD298EC76750E33B4DC0266BB3C7
tipi-v0.0.52-macOS.zip:789E9ADF5A0FBBA2F6013E7360C80C1D2379B21E

## v0.0.51 - Nitfy Nautilus 🐚

### Features

- 🆕 Support for Apple Silicon M1/M2 processors
- 🔥 switching from `make` to `ninja` on many targets for improved build speed
- 🆕 new `tipi download` feature enabling to selectively download build artifacts from the remote build machine

tipi-src: ab5617f1eb1019299ff38fcee89b957570b9bc4e

##### Archives Checksums

tipi-v0.0.51-windows-win64.zip:FDE3CBBEF8201E6BBE1ABBC9DEA15CFBC65EFF69
tipi-v0.0.51-linux-x86_64.zip:6B7F004A6049B00C4218F401F38E0E56085594EA
tipi-v0.0.51-macOS.zip:B0FDCE04902B563790F477AAF0EB86ECC4987B54

## v0.0.50 - Meditative Moose 🦌

### Bug Fixes

- Resolving cache issue 

tipi-src: 87be24b623b467d5737c631be553e9b7e3adb681

##### Archives Checksums

tipi-v0.0.50-windows-win64.zip:38F13DCA256A33123AB647CB02980B9C851C10AB
tipi-v0.0.50-linux-x86_64.zip:4987E15BD7339E17C58025644CAFEB702AAA055B
tipi-v0.0.50-macOS.zip:C455543E8E2EE5F48BBF2B38D81F3EFD6CB935C7

## v0.0.49 - Legit Leopard 🐆

### Features

- ✨Improved support for CMake build dependency files generation in MSVC on Wine target for cloud builds `tipi build . -t linux-wine-msvc`

### Bug Fixes

- Fixed startup hangs when launching MSVC on Wine for the first time on a freshly provisioned machine

tipi-src: ad3222b973e2db4d8bcc2ffc0b16ba8a6f41457f

##### Archives Checksums

tipi-v0.0.49-windows-win64.zip:B324B441D8941975CA2A2C32D47E557562131575
tipi-v0.0.49-linux-x86_64.zip:784E336213DD948D47651F2A0FD89E1C57A5F738
tipi-v0.0.49-macOS.zip:79B7E893BA776DE391C7B4D81232406E38B92A33

## v0.0.48 - Krusty Krab 🧽🦀

### Features

#### Remote Builds
- :new: preview of new MSVC on Wine target for cloud build `-t linux-wine-msvc`

#### General improvements
- improved log outputs for synchronization activities to reduce the log noise especially in verbose and trace level logs

### Bug Fixes
- Large repository checkout workaround using `TIPI_DISABLE_SET_MTIME` is now more resilient
- Remote build checkout was erroneously checking for branch names 

tipi-src: e4153cb3a9472edf4790a62ffab1f230c8078198

##### Archives Checksums

tipi-v0.0.48-windows-win64.zip:F211EE7AB699D7F9D148F60737FC3536E34CBC38
tipi-v0.0.48-linux-x86_64.zip:7D35939FF08A63FA6747D7B07AC87F52281EBF29
tipi-v0.0.48-macOS.zip:EA00297A6D14FB20F8BDB26CB1FA7C1C4C721CD3

## v0.0.47 - Jazzy Jackrabbit 🐰

### Features

#### Remote Builds
- Large repositories like llvm can now be built remotely with fast remote startup time thanks to the support of shallow repository clones and delta pushes. 

### Bug Fixes
- tipi build secure vault properly initialized on first remote build 

tipi-src: 31be27a6b84b552b502208d5dcd2075c788eca70

##### Archives Checksums
tipi-v0.0.47-windows-win64.zip:A79708738F0783BDF050BD37D76FE4489E1ECF11
tipi-v0.0.47-linux-x86_64.zip:2DDC43E84B0D6497206835C7B6A94B4205203C80
tipi-v0.0.47-macOS.zip:0EC359D2651F2DE888CE06907C0478DF442BB492

## v0.0.46 - Iconic Iguana 🦎

### Features

#### Extensibility 
- Tools from Source: Added support for using dependency-provided tools built from source in the build process.
- Host private tools distribution via `distro.json`: Introduced the ability to host a private `distro.json` file in a repository of your choice.
- Runtime environment configuration: Enabled the persistence of build and test runtime environment configuration using the `.tipi/env` (in `dotenv` notation) files.

#### Dependency Management 
* tipi now warns the user when a dependency tree uses two different version of the same library and identifies which library is cause
* Optimized `find_package` in generated build scripts to search only once for a given dependency in complex dependency trees.

### Bug Fixes
- Fixed various bugs related to git submodule handling.
- Enhanced error handling for failed deployment: better error messages and early abort in case of failed deployment of remote build machines.
- Improved error messages when attempting `--sync-build` to a Windows host when synchronized file paths would exceed Windows' maximum supported path length.
- Fixed handling of failing distro downloads: Resolved the issue where failing distro downloads were ignored.

tipi-src : fa163ff06e8d829c6f1862a2ef67ca46414b068a

##### Archives Checksums
tipi-v0.0.46-windows-win64.zip:EC0B904F2C51ED8A4025A3548BC2E2DEC81F8F89
tipi-v0.0.46-linux-x86_64.zip:F76616A3C96749174981127706BA232DEDCA80D5
tipi-v0.0.46-macOS.zip:F02BF888C33F74D2A68C0B0015BD56C61293845B



## v0.0.45 - Hastened Hamster 🐹

### Bugfix
  - Fix `--sync-build` when proxy settings are in use
  - `.gitignore`d files are properly mirrored
  - Fix last state file synchronization when running remote command with `tipi .run` 

tipi-src : afbd584f60e0eadb4772dee27cda7e7d348e0f0f

##### Archives Checksums
tipi-v0.0.45-windows-win64.zip:6C3841156C13F2230CF6B746DDC180E9BC13885A
tipi-v0.0.45-linux-x86_64.zip:A699C69EFFCED994CD318353BFD7EA0CAB34CEF9
tipi-v0.0.45-macOS.zip:E08258A1D2C0DE9FCC1D7CC107795E86D689D65A


## v0.0.44 - Glorious Goldfish 🐟

### Feature
  - `--test-jobs <NUMBER>` allows to specify a different test execution parallelity level than the provided `--jobs / -j` flag

### Bugfix
  - Code in submodules is rebuilt only when changed 
  - Fix crash when building a subfolder of a project with submodules
  - Subfolder builds of project with submodule are correctly mirrored (only submodules within the built subfolder are mirrored)
  - Dependencies fetched via a Git annotated tag reference in `{ "@" : "vX.X.X" }`  are now properly authenticated
  - Remote `tipi .run` command properly synchronizes sources up and allow using subfolder paths.

##### Archives Checksums
tipi-v0.0.44-windows-win64.zip:E87E3A9C443FC051EDA77124A17C3D6CEB5B92F8
tipi-v0.0.44-linux-x86_64.zip:ACA531A447001FCF38101A5B20A581C0055641D4
tipi-v0.0.44-macOS.zip:05B1E172CD8B4C46A982D35E59BF17ED0754F595

## v0.0.43 - codename Flamboyant Fox 🦊

## Features
 - Git Submodules support : local and remote build of main project as well as for dependencies
 - 🔥 BEHAVIOUR CHANGE : `.tipi/opts` files are now only propagated to the current project built, while `.tipi/opts.toolchain` extends the toolchain and impacts the abi-hash of all dependencies.
 - Added gcovr in standard tipi linux images for Code Coverage reports
 - Coverage support with llvm-lcov (gcov compatible) on all platforms
 - Support for iptables and raw networking added in linux remote jobs ( i.e. useful for test executions )
 
##### Archives Checksums
tipi-v0.0.43-windows-win64.zip:794C5DEE5DA55BB81CAFBD51F13605376B03C123
tipi-v0.0.43-linux-x86_64.zip:D1486F74396FADF8DBD9D7A4955ABBD483028A71
tipi-v0.0.43-macOS.zip:AA0C3C836BA1A9370F57BA0E66403FB596E77B73

## v0.0.42 - codename Electric Elk ⚡🦌

## Bugfix

 - fix tipi crash when a test fail in quiet mode

tipi-src: fe1dff44985608ca9f80041945e7bbfd6aca5f17

##### Archives Checksums
tipi-v0.0.42-windows-win64.zip:DB79C2279EF9E353F1E212E67A6A17C194C1DBFA
tipi-v0.0.42-linux-x86_64.zip:E8BE7A26F216C8AED848C11775FEB7C626D89B20
tipi-v0.0.42-macOS.zip:DF100428ACE210AD4025EAD2E3DBD26C5A4A0772


## v0.0.41 - codename Decisive Dolphin 🐬

## Feature
 
### Remote build
 - Improved reliability of remote Job machine underlying SSH connection (also automatically using different ports if already in-use )

### Test Driven Development monitor mode
 - 🚀 Monitor mode fully overhauled with debouncing and discard of running build
 - Support passing command line arguments to test executables and control test via `<projdir>/.tipi.test-args`

### Package Management
 - 🚀 Speedup for dependencies install : even on first build the dependencies are properly resolved from the cache.
 - Correct setup of CMake package configuration find directories when a project is built from cache a second time
 - Dependencies now stay a dependencies of the proper level and are no more added recursively to all parent levels
 - Possibility to specify the `.tipi/id`  cache id key directly in `.tipi/deps` ( useful when it differs from github origin )
 - `{ "opts" : "set(CMAKE_VAR ON)" }` can be specified in `.tipi/deps`.
 - `TIPI_CACHE_CONSUME_ONLY=ON` in the environment allows use of the cache without populating it.

## Bugfix
 - `--sync-build` of remotely built project returns the binary built and doesn't generate an infinitely expanding archive anymore.
 - Remote build of incremental changes on already built files are not ignored anymore (modification time correctly set up to the nanosecond)
 - Remote Build doesn't hang anymore in remote subprocesses builds on windows until `<Enter>` is pressed.
 - Properly detect what changes in build by convention mode, by regenerating cmakelists when they actually change
 - Projects opts files in dependency chain are inlined to the CMake toolchain file in proper order, so that dependent  project can override toolchain specific settings for their dependencies
 - symlinks are properly stored and extracted on windows build caches 
 - `tipi . --test <filter-regex>` now properly forwards it to CMake-CTest on windows.

tipi-src: 9231ede55a3a24b2755d3311dfa12d63203d159e

##### Archives Checksums
tipi-v0.0.41-windows-win64.zip:A0E8DF4CA67F87238A01894CB75B82453207D6A0
tipi-v0.0.41-linux-x86_64.zip:FA72E1620EE9949C13B58139CB027861A1A2BAFB
tipi-v0.0.41-macOS.zip:EAF1B13D04D3D8F320409D1D0B7775078C70BAD0

## v0.0.39 - codename California Condor 🦅

### Feature 
 - 🚀 60% faster cache extraction on incremental builds ( extracts only changed files across revisions )
 - 🚀 2 times faster mirroring of sources on exact cache hit
 - 🚀 3 time fasters incremental builds for CMakeLists based build ( { "u" : true } builds), the configure step is done only when strictly required.
 - Platform Library now built and packed only if needed by the `.tipi/deps`
 - Dependencies built by a project also populate the build packs caches (Allows to benefit from incremental builds  when a dependency is frequently updated)

### Bugfix
 - Cache creation of unchanged build files after commit doesn't result in needless rebuilds on cache extraction.
 - transitive dependencies on cache restore works ( More than 1 level of dependencies ) 
 - Switching between CMakeList and build by conventions works seamlessly ( Fix tipi-build/community-support#3, thanks @stefanofiorentino, thanks @Bjoe)
 - HTTP Proxy support for remote builds fixed

tipi-src: d8feb61111d63245abd7b6d9dfa6a957545d2367

##### Archives Checksums
tipi-v0.0.39-windows-win64.zip:ED248C4D375E00F805515445D18441F4E289272D
tipi-v0.0.39-linux-x86_64.zip:37E9894864B9AEE3A5E498CC04B9F9CA0ABC0364
tipi-v0.0.39-macOS.zip:A0369556D1DCA8197B0FC33D99DAA83BFCDEAE65

## v0.0.38 - codename Blissful Buffalo 🐃

### Feature
 - 🚀 Drastically improved cache retrieval as only the binary tree is fetched and only required pieces on partial cache hit
 - 🚀 Drastically improved cache performance : no user side repacking
 - 🚀 Proper support with caching for local+remote subfolder dependencies
 - 🚀 Full remote build and caching support to build subfolders ( e.g. monorepos build scenarii ) 
 - 🚀 Faster remote build sources prefetching with faster hardlinking from central intermediate repository to cache pushes
 - 💄 Cleaned up output and Added spinners for IO Bound tasks like cache fetch, updload


### Bugfix
 - tipi cache multithreaded 🧵 symlinks extraction bug resolved
 - tipi cache extraction works now with missing symlink target (symlink pointing to non-existent target)
 - Removed possible infinite loop hanging the output in the rewriter for mirrored file paths 
 - `tipi .run` works as expected (symlinks on remote run get maintained) (fixes thttps://github.com/tipi-build/community-support/issues/1 - thank you @Bjoe for reporting)
 - Support remotely prefetching repo cloned locally with SSH
 - Dropped aging Eclipse Project support

##### Archives Checksums
 tipi-v0.0.38-windows-win64.zip:0F1D7D386648681BFCAF8BC55029D86E5D8C7D05
 tipi-v0.0.38-linux-x86_64.zip:BBE51A2C98788569A5A9BE0B348DCFB4F2793DC6
 tipi-v0.0.38-macOS.zip:0FC6B02440DA9B06F4500876DDA42B9F840B0492


## v0.0.37 - codename Angelic Anteater 🐾

### Bugfix
 - tipi cache stores and restores correclty permission bits, execution bits and symlinks
 - Optimized cache HIT check on projects that had cache entries but none related to any commit of the current branch ( on bigger project it could be stuck for hours )

##### Archives Checksums
tipi-v0.0.37-windows-win64.zip:377F167CC6ED7FEF65D07A88CB0C84BFB29DF224
tipi-v0.0.37-linux-x86_64.zip:A84573E0E1E691F6FF77B5D5CD1BDC14E08CBDAD
tipi-v0.0.37-macOS.zip:BEC661DD4C5F55807572C381E538FF69FFF5AC04

## v0.0.36 - codename Zealful Zebra 🦓

### Feature
  - 🆕 ✨ Compiler output rewriting for better usability and legible paths
  - 🚀 Improved cache performance

### Bugfix
 - Cross platform remote `--sync-build` works again
 - Fixed remote Windows live builds
 - Fixed live build change detection on Linux 
 - Improved path lengths of local source mirroring to reduce risk of MAX_PATH_LENGHT issues on Windows
 - Fixed shallow clone crash (root commit detection failures)
 - Human-readable CMake export names


### Breaking changes & known bugs:
 - File permission incorrectly set during cache restore
 - Changes in the `.tipi/` folder structure. You should probably clear the `.tipi/d` folder (`/usr/local/share/.tipi/d` in Linux and macOS and `C:\.tipi\d` for Windows users)

##### Archives Checksums
tipi-v0.0.36-windows-win64.zip:01B2E808DF0E4216F3CC1E43080FDBFFE5DC048C
tipi-v0.0.36-linux-x86_64.zip:2CCBC5E9381C96D339C12FBE2960515ACCA1AC1E
tipi-v0.0.36-macOS.zip:33F5F510655D5126321E11DA35F13DE42FAEDA31

## v0.0.35 - codename Yodeling Yak @ CppCon 🤠 

### Feature
  - Full rewrite of the file synchronization system
  - (PREVIEW) Tipi.build Cache (requires tipi.build account & link to Github.com)
    - Private dependency snapshots
  - Highly improved isolation between dependencies
  - (PREVIEW) Support for self-hosted remote nodes

### Bugfix
  - `--sync-build` now synchronizes build trees as whole snapshots for improved consistency
  - Some `.tipiignore` rules could not be overwritten

### Breaking changes & known bugs:

  - `TIPI_HOME_DIR` now obsolete / ignored
  - Location of `.tipi/` moved to `/usr/local/share/.tipi` (Linux and macOS) and `C:\.tipi` (Windows)
    - **NOTE:** you may have to re-run the installer to fix up the permissions depending on your setup
    - **RATIONALE:** minimizes the need for path rewriting on build cache hits     
  - `--sync-build` is broken on some Windows installs especially when used in conjunction with `--monitor`

##### Archives Checksums
tipi-v0.0.35-windows-win64.zip:86EC51AB365C8D686DF87F77809706AE171421E3
tipi-v0.0.35-linux-x86_64.zip:DF5FC190EBA8C5E8A418107984072DD1AB082F72
tipi-v0.0.35-macOS.zip:B620BD356DEEDE35144B9AD5A0D480726C24AAA8

## v0.0.34 - codename Xenodochial Xoloitzcuintli 🐶

### Feature
  - Build for legacy Ubuntu 16.04 in remote builds with the command :  `tipi build . -t linux-ubuntu-16.04[-cxx14|-cxx17]`
 
tipi-src : 2ba5d05093e0e5caab1e8aed7a7436e99af9cb66

##### Archives Checksums
tipi-v0.0.34-windows-win64.zip:4DDFA5AA5C49315D7746FE6265AF7B0C117BE2EC
tipi-v0.0.34-linux-x86_64.zip:1CAEE4DA8177F6CCDC29F86599CE9A7619DFA56F
tipi-v0.0.34-macOS.zip:440735998EFBDE53D2A22A8814A67671A4617E93

## v0.0.33 - codename Wonderful Wallaby 🦘

### Bugfix
  - Fix wasm builds on linux `Failed to fetch compiler version information with command "'/.tipi/emsdk/f693e7f/upstream/emscripten/emcc' -v"`
  - Fix remote builds that were always verbose even without `--verbose` 
  - Native modules for python on linux are all packaged with now thanks to tipi upcoming bundle utilities
  - Explicit fail when installing tipi on Apple Sillicon (Mac M1 & M2) until we support the architecture.

##### Archives Checksums
tipi-v0.0.33-windows-win64.zip:F2CBF42ED69C2C569F9379525FC769BBB972EE95
tipi-v0.0.33-linux-x86_64.zip:83359EF97E00442CF4DC906D8E35D41D23D606A3
tipi-v0.0.33-macOS.zip:662063103AB96391E95E96EF81E2848176EB6ABA


## v0.0.32 - codename Velvety Vicugna 🦙

### Feature
  - 🆕 ✨ more glam for the CLI
	  - listing of executables and tests (fixed #26 - thank you @sandordargo)
	  - improved dialog / user input handling with default answers
	  - coloring and newline consistency fixed (#27 and many more - thank you again @sandordargo)
	  - coloring of remote machine output
	  - more control over log verbosity (`-v` to `-vvv` for most detail)
	  - generally better and more helpful messages 
  - Improved support Ubuntu 16.04 ext LTS + Ubuntu 18.04
  - Improved upgrade installation experience

### Bugfix
  - Fixed bug in the include scanner and inclusion root detection
  - Windows installer script improved: 
	  - installation into the User's Local AppData by default to enable installation and upgrades in non-elevated environments / without administrative rights (fixes #31)
	  - the installer checks for the install path being on PATH to avoid multiple insersions
	  - insersion into system / user PATH doesn't mix up sources (fixes #34)
	  - generally better textual output
  - Linux installer:
	  - setting the file access rights and ownership to allow in-place upgrading without priviledge elevation / `sudo`
	  - generally better textual output
  - PATH manipulation in tipi are now case insensitive (fixes tipi-build/cli#33 - thank you @stefanofiorentino)
  - Remote environment specification is now stable and reproducible accross supported hosts

### ⚠️ Upgrade process ⚠️ 
⚠️ Upgrading by answering yes below won't work. 
Use the install scripts oneliner to upgrade tipi : https://tipi.build/onboarding/step3

##### Archives Checksums
tipi-v0.0.32-windows-win64.zip:A061E65CEAC3729D12A354FC26B7A569A9D292DE
tipi-v0.0.32-linux-x86_64.zip:8F8171D71DD11F7C75EEBA66BFF9A7ECB0CBC922
tipi-v0.0.32-macOS.zip:9CC73AE51B7B53790180E946148C8C514CA83B25

## v0.0.31 - codename **unique unicornfish** 🐟

### Feature
  - Limited official support for Ubuntu 16.04 ext LTS + Ubuntu 18.04 (use remote builds from your legacy Ubuntu 16+)

### Bugfix
  - Building on macOs remote environment works again
 
tipi-src 6e74e70152174a509968d0d33e517527f30d49eb

##### Archives Checksums
tipi-v0.0.31-windows-win64.zip:AA54BC0EF43701252BC3CF5DB6E153C79BD18A51
tipi-v0.0.31-linux-x86_64.zip:CE101029F9ED9F2135010606F53D942715E4A426
tipi-v0.0.31-macOS.zip:7D0D885891DBA7541DD5AE5AA13BAE19D8107AEC


## v0.0.30 - codename **transcendent tayen** 🌑
## Bugfix
  - `tipi connect` working again on windows / fixed a number formatting error

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



