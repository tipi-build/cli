
# tipi.build
Please head up to [our website](https://tipi.build)

## Features
- Provides a fully working C++ build environment on any platform
- tipi speeds up your workflow with autoprovisioned cloud environments : toolchain, compilers, tools.
- tipi is a dependency manager for C++ which fetches and compile any C++ project.
- tipi builds superfast with cloud powered build distribution that features enough RAM and Disk size.

## Flavours
Available as command line tool or vscode plugin !

## Support
* [Ask us on Github Issues](https://github.com/tipi-build/cli)
* [Contact via our Website](https://tipi.build)

### Add to vscode

[Click Here to add tipi.build to vscode](vscode:extension/tipi.tipi-build)

![add to vscode](./tipi-build-plugin.png)

### Install on Linux / macOS 
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tipi-build/cli/master/install/install_for_macos_linux.sh)"`

Paste that in a Linux shell prompt or in a macOS Terminal.

### Install on Windows 10
```
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Ssl3
[Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"
. { iwr -useb https://raw.githubusercontent.com/tipi-build/cli/master/install/install_for_windows.ps1 } | iex
```

Paste that in a Powershell (run as Administartor).


# License
Binaries delivered here are under copyright by tipi.build, see [LICENSE](./LICENSE)

Open-source projects like Boost, CMake, Emscripten, Hunter and thousands of other libraries are the giants' shoulders tipi.build is standing on. The tipi.build project is happy and truly thankful to live in a time where we can participate in such lively and creative communities with so many cool ideas and so much passion. Without those, developing tipi.build would not have been possible.

Open-source lets us take part in building the future. Let’s do it together.

Therefore here the opensource components, release as opensource code developed by tipi.build : 
  * [nxxm/gh](https://github.com/nxxm/gh)
  * [nxxm/htmlpp](https://github.com/nxxm/htmlpp)
  * [nxxm/cli\_widgets](https://github.com/nxxm/cli_widgets)
  * [xxhr : HTTP at your fingertips](https://github.com/tipi-build/xxhr)
