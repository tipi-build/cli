$INSTALL_FOLDER="C:\ProgramData\tipi"
$TIPI_URL="https://github.com/tipi-build/cli/releases/download/v0.0.15/tipi-v0.0.15-windows-win64.zip"
$TIPI_EXE="$INSTALL_FOLDER\tipi.exe"
$texte = '#include <iostream>
int main()
{
std::cout<<"Welcome in tipi"<<std::endl;
return 0;
}'

function Abort {
    param (
        $Message
    )
   Write-Output " $Message "
}

function Info {
    param (
        $Message
    )
  Write-Output "---> $Message "
}

function New-TemporaryDirectory {
  $parent = [System.IO.Path]::GetTempPath()
  [string] $name = [System.Guid]::NewGuid()
  $path = (Join-Path -Path $parent -ChildPath $name)
  New-Item -ItemType Directory -Path $path
  return $path
}

info "Downloading tipi..."

$download_dir = New-TemporaryDirectory
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$downloaded_tipi_zip = (Join-Path -Path $download_dir -ChildPath "tipi.zip")[0]
Write-Output "Dowloading tipi archive in $downloaded_tipi_zip"
Invoke-WebRequest -Uri $TIPI_URL -OutFile $downloaded_tipi_zip

if(!$?) {
    Abort("Could not download tipi")
    return
}

info "Installing tipi in $INSTALL_FOLDER"
$tipi_source_exe = $download_dir[0]
$tipi_source_exe = "$tipi_source_exe\bin\tipi.exe"

New-Item -Force -ItemType Directory -Path $INSTALL_FOLDER
Expand-Archive -Force -path $downloaded_tipi_zip -destinationpath $download_dir[0]
Copy-Item -Force $tipi_source_exe -Destination $TIPI_EXE

if (!$?){
   Abort("Could not install tipi")
   return
}

[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$INSTALL_FOLDER",
    [EnvironmentVariableTarget]::Machine)

if (!$?){
   Abort("Could not put tipi on the Path environment variable")
   return
}

info "tipi is installed, downloading included tools."
$installdeps_folder = New-TemporaryDirectory
$installdeps_file = (Join-Path -Path $installdeps_folder -ChildPath "installdeps.cpp")[0]
$text = $texte | Out-File -Encoding "ASCII" -FilePath "$installdeps_file"

cmd.exe /c "$TIPI_EXE --verbose $installdeps_folder"   
if ($?){
    info "tipi has been installed in $INSTALL_FOLDER. In either a new cmd of after a reboot tipi will be available on your Path."
 
}else{
    Abort "Installation failed, please contact us on https://tipi.build : We would be happy to help you."
    [Environment]::Exit(1)  
}
