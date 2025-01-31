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

$Definitions = @{VULKAN_HEADERS_INSTALL_DIR = $prefix}

function Build {
    Param(
        [string]$ProjectName,
        [string[]]$Defines
    )

    $defs = ""

    foreach ($def in $Defines) {
        $definition = $Definitions[$def]
        $defs += "-D $def=$definition"
    }

    Write-Host ""
    Write-Host "$ProjectName"
    Write-Host "======================="
    Write-Host ""

    $build_dir_project = "$build_dir\$ProjectName"
    & cmake -B $build_dir_project -G Ninja -S $ProjectName $defs
    & cmake --build $build_dir_project --config $config
    & cmake --install $build_dir_project --prefix $prefix --config $config
}

Build -ProjectName "Vulkan-Headers"
Build -ProjectName "Vulkan-Loader" -Defines @("VULKAN_HEADERS_INSTALL_DIR")
Build -ProjectName "Vulkan-Utility-Libraries" -Defines @("VULKAN_HEADERS_INSTALL_DIR")
