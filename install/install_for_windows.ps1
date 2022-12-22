# tipi CLI windows installer script
# Copyright 2020 - () tipi technologies Ltd (Zürich)
#
# Environment variables
#
# - TIPI_INSTALL_VERSION:   overrides release to install - must match release tag 
# - TIPI_INSTALL_DEST:      overrides the default installation destination
# - TIPI_INSTALL_SOURCE:    override the source path of the release zip
#                           -> a file:// url can be used to install from a locally present zip
# - TIPI_INSTALL_SYSTEM:    set to "True" to proceed to a system-wide install of tipi
#                           ->  depending on the value of TIPI_INSTALL_DEST tipi will be installed
#                               in %TIPI_INSTALL_DEST% or "%CommonApplicationData%\tipi\" (on most
#                               systems that interpolates to C:\ApplicationData\tipi)
#                           ->  if run in an elevated promt the installation path witll be 
#                               preprended to the SYSTEM::PATH instead of the USER_PROFILE::PATH
#                               which places tipi.exe on the path of all users of the system
#

###
# Helper functions
###

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

###
# Impl.
###

$version_to_use = $env:TIPI_INSTALL_VERSION
$INSTALL_FOLDER = $env:TIPI_INSTALL_DEST

$system_install = $false
if([bool]::TryParse($env:TIPI_INSTALL_SYSTEM, [ref]$system_install)) {
    Write-Output "INFO: TIPI_INSTALL_DEST set, interpreted as boolean '$system_install'"
}

if ([string]::IsNullOrEmpty($version_to_use)) {
    $version_to_use="v0.0.39"
}

if ([string]::IsNullOrEmpty($INSTALL_FOLDER)) {
    if($system_install) {
        $INSTALL_FOLDER = Join-Path -Path ([Environment]::GetFolderPath('CommonApplicationData')) -ChildPath "\tipi"
    }
    else {
        $INSTALL_FOLDER = Join-Path -Path ([Environment]::GetFolderPath('LocalApplicationData')) -ChildPath "\tipi"
    }    
}


$TIPI_URL = $env:TIPI_INSTALL_SOURCE

if ([string]::IsNullOrEmpty($TIPI_URL)) {
    $TIPI_URL = "https://github.com/tipi-build/cli/releases/download/$version_to_use/tipi-$version_to_use-windows-win64.zip"
}

$TIPI_EXE = "$INSTALL_FOLDER\tipi.exe"


Info "Downloading tipi from: $TIPI_URL"

$download_dir = New-TemporaryDirectory
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$downloaded_tipi_zip = (Join-Path -Path $download_dir -ChildPath "tipi.zip")[0]
Info "Saving archive to: $downloaded_tipi_zip"

# note: disabling the progress bar of the invoke-webrequest using the "magic" global
# accelerates the download by ~10x 
# (+) setting the content type to octet-stream prevents the web client behind 
# invoke-webrequest to try and parse the response at each received chunk
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -ContentType "application/octet-stream" -Uri $TIPI_URL -OutFile $downloaded_tipi_zip

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

Info "Installing tipi in: $INSTALL_FOLDER"
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

if($system_install -and -not $runningWithPrivileges) {
    Write-Warning "System install required administrative priviledges to add tipi to the system PATH."
    Write-Warning "Please re-run this script in an elevated promt if you need all users to be able to use tipi."
    Write-Warning "-> Proceeding to add tipi to the current user's PATH."
}

# this checks if the path to tipi is contained in the %Path% 
# note: we read out of context so we get the value that was used - no matter the code path on
# the last installation
$INSTALL_FOLDER_regex_escaped = $INSTALL_FOLDER.replace("\", "\\")
if([Environment]::GetEnvironmentVariable("Path") -match "(^|;)$INSTALL_FOLDER_regex_escaped(;|$)") {
    Info "Install folder already on your PATH - done"
} else {
    $context = [EnvironmentVariableTarget]::User;

    if($runningWithPrivileges -and $system_install) {
        $context = [EnvironmentVariableTarget]::Machine
    }

    $PATH_orig = [Environment]::GetEnvironmentVariable("Path", $context)

    $PATH_new = "$INSTALL_FOLDER;" + $PATH_orig # prepending so the latest install wins the path race
    $PATH_new = $PATH_new -replace ';{2,}',';'  # clean the path of eventual double ;; entries

    [Environment]::SetEnvironmentVariable("Path", $PATH_new, $context)

    if (!$?){
        Abort "Could not put tipi on the Path environment variable"
        return
    }

    Info "Added tipi to your user path only."
    Info 'NOTE: Please set $Env:TIPI_INSTALL_SYSTEM="True" and re-run the install script in an admin console if you need other users on your machine use tipi.'

    # "refresh" then current console session PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

Info "Cleaning up temporary download folder"
Get-ChildItem -Path $download_dir -Recurse | Remove-Item -force -recurse


Info "Provisioning included tools."
$color_before = $host.ui.RawUI.ForegroundColor
cmd.exe /c "$TIPI_EXE -v --dont-upgrade run echo ""[INFO] Shipping tools done"""
$host.ui.RawUI.ForegroundColor = $color_before

if ($?){
    Info "tipi has been installed in $INSTALL_FOLDER and can be used now. You may have to start a new terminal / command window."
    Write-Output "----------------------------"
    Info "If you are new to tipi you can explore how to use it at: https://tipi.build/explore. If you are currently following the onboarding guide it is now time to get back to your browser: https://tipi.build/onboarding/step4"
}else{
    Abort "Installation failed, please contact us on https://tipi.build : We are happy to help."
    [Environment]::Exit(1)  
}

