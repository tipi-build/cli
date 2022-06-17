# Test install succeeeded 

$pathsToTest = @(
    "C:\\ProgramData\\tipi\\tipi.exe"   
    "C:\\.tipi\\environments\\*\\xcode.cmake" 
    "C:\\.tipi\\openssh\\*\\ssh.exe"
    "C:\\.tipi\\python\\*\\python.exe"  
    "C:\\.tipi\\file-sync\\*\\pysearpc\\client.py"  
)

$success = $true

foreach ( $testPath in $pathsToTest )
{
    if (!(Test-Path $testPath -PathType leaf)) { 
        echo "[FAIL] Expected <$testPath> was not found in installation."
        $success = $false; 
    }
}


# test just a few things in the light install to make sure they are *NOT* present
$pathsToTest_negative = @(
    "C:\\ProgramData\\tipi\\tipi.exe"  
    "C:\\.tipi\\clang\\*\\bin\\clang.exe"  
    "C:\\.tipi\\cmake\\*\\bin\\cmake.exe"  
    "C:\\.tipi\\emsdk\\*\\emsdk.bat"              
    "C:\\.tipi\\go\\*\\bin\\go.exe"  
    "C:\\.tipi\\jdk\\*\\bin\\jar.exe"              
)

foreach ( $testPath in $pathsToTest_negative )
{
    if (Test-Path $testPath -PathType leaf) { 
        echo "[FAIL] Unexpected <$testPath> was found in installation."
        $success = $false; 
    }
}


if(!$success) { exit 1; }