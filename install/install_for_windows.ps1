

$version_to_use=$env:TIPI_INSTALL_VERSION

if ([string]::IsNullOrEmpty($version_to_use)) {
    $version_to_use="v0.0.31"
}

$INSTALL_FOLDER = "C:\ProgramData\tipi"
$TIPI_EXE = "$INSTALL_FOLDER\tipi.exe"
$TIPI_URL = "https://github.com/tipi-build/cli/releases/download/$version_to_use/tipi-$version_to_use-windows-win64.zip"

function Abort {
    param (
        $Message
    )
    $color_before = $host.ui.RawUI.ForegroundColor
    $host.ui.RawUI.ForegroundColor = 'Red'
    Write-Warning "[x] $Message"
    $host.ui.RawUI.ForegroundColor = $color_before
}

function Info {
    param (
        $Message
    )
    Write-Output "-> $Message"
}

function New-TemporaryDirectory() {
    $parent = [System.IO.Path]::GetTempPath()
    [string] $name = [System.Guid]::NewGuid()
    $path = (Join-Path -Path $parent -ChildPath $name)
    New-Item -ItemType Directory -Path $path
    return $path
}

Info "Downloading tipi..."

$download_dir = New-TemporaryDirectory
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$downloaded_tipi_zip = (Join-Path -Path $download_dir -ChildPath "tipi.zip")[0]
Info "Dowloading tipi archive in $downloaded_tipi_zip"
Invoke-WebRequest -Uri $TIPI_URL -OutFile $downloaded_tipi_zip

if(!$?) {
    Abort "Could not download tipi"
    return
}

# test if the user can write to $TIPI_EXE
Try { 
    if([System.IO.File]::Exists($TIPI_EXE)) {
        [System.IO.File]::OpenWrite($TIPI_EXE).close()
    }
}
Catch { 
    Write-Warning "Unable to write to $TIPI_EXE - please re-run this script with appropriate privileges (or delete the file manually)" 
    return
}

Info "Installing tipi in $INSTALL_FOLDER"
$tipi_source_exe = $download_dir[0]
$tipi_source_exe = "$tipi_source_exe\bin\tipi.exe"

New-Item -Force -ItemType Directory -Path $INSTALL_FOLDER | Out-Null
Expand-Archive -Force -path $downloaded_tipi_zip -destinationpath $download_dir[0] | Out-Null
Copy-Item -Force $tipi_source_exe -Destination $TIPI_EXE | Out-Null

if (!$?){
    Abort "Could not install tipi"
    return
}

# detection of admin rights for this script
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$runningWithPrivileges = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# this checks if the path to tipi is contained in the %Path% 
# note: we read out of context so we get the value that was used - no matter the code path on
# the last installation
$INSTALL_FOLDER_regex_escaped = $INSTALL_FOLDER.replace("\", "\\")
if([Environment]::GetEnvironmentVariable("Path") -match "(^|;)$INSTALL_FOLDER_regex_escaped(;|$)") {
    Info "Install folder already on your PATH - skipping"
} else {
    $context = [EnvironmentVariableTarget]::User;

    if($runningWithPrivileges) {
        $context = [EnvironmentVariableTarget]::Machine
    }

    $PATH_orig = [Environment]::GetEnvironmentVariable("Path", $context)

    $PATH_new = $PATH_orig + ";$INSTALL_FOLDER;"
    $PATH_new = $PATH_new -replace ';{2,}',';'  # clean the path of eventual double ;; entries

    [Environment]::SetEnvironmentVariable("Path", $PATH_new, $context)

    if (!$?){
        Abort "Could not put tipi on the Path environment variable"
        return
    }

    Info "Added tipi to your user path only. Please re-run the install script in an admin console if you need other users on your machine use tipi."
}

Info "Cleaning up temporary download folder"
Get-ChildItem -Path $download_dir -Recurse | Remove-Item -force -recurse


Info "Provisioning included tools."
$color_before = $host.ui.RawUI.ForegroundColor
cmd.exe /c "$TIPI_EXE --dont-upgrade run echo done"
$host.ui.RawUI.ForegroundColor = $color_before

if ($?){
    Info "tipi has been installed in $INSTALL_FOLDER and can be used now. You may have to start a new terminal / command window."
    Write-Output "----------------------------"
    Info "If you are new to tipi you can explore how to use it at: https://tipi.build/explore. If you are currently following the onboarding guide it is now time to get back to your browser: https://tipi.build/onboarding/step4"
}else{
    Abort "Installation failed, please contact us on https://tipi.build : We are happy to help."
    [Environment]::Exit(1)  
}
