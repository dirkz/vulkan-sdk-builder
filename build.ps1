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
    Write-Host "*** definitions: $defs"
    Write-Host ""

    $build_dir_project = "$build_dir\$ProjectName"

    & cmake -B $build_dir_project -G Ninja -S $ProjectName $defs
    & cmake --build $build_dir_project --config $config
    & cmake --install $build_dir_project --prefix $prefix --config $config
}

Build -ProjectName "Vulkan-Headers"
Build -ProjectName "Vulkan-Loader" @("VULKAN_HEADERS_INSTALL_DIR")
Build -ProjectName "Vulkan-Utility-Libraries" @("VULKAN_HEADERS_INSTALL_DIR")
Build -ProjectName "SPIRV-Headers"

$spirvHeaderDir = "$PSScriptRoot\SPIRV-Headers"
$spirvHeaderDir = $spirvHeaderDir -replace '\\', '/'
$definitions = @{
    "SPIRV-Headers_SOURCE_DIR" = $spirvHeaderDir
    SPIRV_WERROR = "OFF"
    SPIRV_SKIP_TESTS = "ON"
    SPIRV_SKIP_EXECUTABLES = "OFF"
}
Build -ProjectName "SPIRV-Tools" @() $definitions

$definitions = @{ RH_STANDALONE_PROJECT = "OFF" }
Build -ProjectName "robin-hood-hashing" @() $definitions

$definitions = @{
    MI_BUILD_STATIC = "ON"
    MI_BUILD_OBJECT = "OFF"
    MI_BUILD_SHARED = "OFF"
    MI_BUILD_TESTS = "OFF"
}
Build -ProjectName "mimalloc" @() $definitions

$definitions = @{
    ENABLE_OPT = "OFF"
}
Build -ProjectName "glslang" @() $definitions

$definitions = @{
    VulkanHeaders_DIR = "$prefix\share\cmake\VulkanHeaders"
    VulkanUtilityLibraries_DIR = "$prefix\lib\cmake\VulkanUtilityLibraries"
}
Build -ProjectName "Vulkan-Profiles" @() $definitions
