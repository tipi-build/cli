

$version_to_use=$env:TIPI_INSTALL_VERSION

if ([string]::IsNullOrEmpty($version_to_use)) {
    $version_to_use="v0.0.31"
}

$INSTALL_FOLDER = "C:\ProgramData\tipi"
$TIPI_EXE = "$INSTALL_FOLDER\tipi.exe"
$TIPI_URL = "https://github.com/tipi-build/cli/releases/download/$version_to_use/tipi-$version_to_use-windows-win64.zip"

# this checks if the path to tipi is contained in the %Path%
$INSTALL_FOLDER_regex_escaped = $INSTALL_FOLDER.replace("\", "\\")

$input = "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;C:\Program Files\Amazon Corretto\jdk11.0.8_10\bin;C:\Program Files (x86)\STMicroelectronics\st_toolset\asm;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files\dotnet\;C:\Program Files (x86)\STMicroelectronics\STM32 ST-LINK Utility\ST-LINK Utility;C:\Program Files (x86)\PDFtk\bin\;C:\ProgramData\chocolatey\bin;C:\ProgramData\tipi;C:\Program Files (x86)\GitExtensions\;C:\Program Files\Git\cmd;C:\Program Files\nodejs\;C:\ProgramData\npm\npm;;C:\Program Files\Docker\Docker\resources\bin;C:\ProgramData\DockerDesktop\version-bin;C:\ProgramData\tipi;dd"

if($input -match "(^|;)$INSTALL_FOLDER_regex_escaped(;|$)") {
    Write-Output "Install folder already on your PATH - skipping"
} else {
    
    Write-Output "Added tipi to your user path only. Please re-run the install script in an admin console if you need other users on your machine use tipi."
}
