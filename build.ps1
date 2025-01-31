Param(
   [switch]$Clean
)

#$version = "vulkan-sdk-1.4.304"
#$nl = [Environment]::NewLine

$build_dir = "$PSScriptRoot\build"
$prefix = "$PSScriptRoot\install"
$config = "Debug"

if ($Clean)
{
    Remove-Item -LiteralPath $build_dir -Force -Recurse
}

$Definitions = @{
    VULKAN_HEADERS_INSTALL_DIR = $prefix
}

function Build {
    Param(
        [string]$ProjectName,
        [string[]]$Keys,
        [hashtable]$UniqueDefinitions
    )

    $defs = @()

    foreach ($key in $Keys) {
        $definition = $Definitions[$key]
        $defs += "-D$key=$definition"
    }

    foreach($key in $UniqueDefinitions.Keys) {
        $definition = $UniqueDefinitions[$key]
        $defs += "-D$key=$definition"
    }

    Write-Host ""
    Write-Host "$ProjectName"
    Write-Host "======================="
    Write-Host ""
    Write-Host "*** defs: $defs"
    Write-Host ""

    $build_dir_project = "$build_dir\$ProjectName"

    & cmake -B $build_dir_project -G Ninja -S $ProjectName $defs
    & cmake --build $build_dir_project --config $config
    & cmake --install $build_dir_project --prefix $prefix --config $config
}

Build -ProjectName "Vulkan-Headers"
Build -ProjectName "Vulkan-Loader" -Defines @("VULKAN_HEADERS_INSTALL_DIR")
Build -ProjectName "Vulkan-Utility-Libraries" -Defines @("VULKAN_HEADERS_INSTALL_DIR")
Build -ProjectName "SPIRV-Headers"

$spirvHeaderDir = "$PSScriptRoot\SPIRV-Headers"
$spirvHeaderDir = $spirvHeaderDir -replace '\\', '/'
$spirvToolsDefinitions = @{
    "SPIRV-Headers_SOURCE_DIR" = $spirvHeaderDir
    SPIRV_WERROR = "OFF"
    SPIRV_SKIP_TESTS = "ON"
    SPIRV_SKIP_EXECUTABLES = "OFF"
}
Build -ProjectName "SPIRV-Tools" @() $spirvToolsDefinitions
