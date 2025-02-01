Param(
   [switch]$Clean
)

$version = "1.4.304" # tag is vulkan-sdk-1.4.304
#$nl = [Environment]::NewLine

$build_dir = "$PSScriptRoot\build"
$prefix = "c:\Vulkan\$version"
$config = "Release"

if ($Clean)
{
    Remove-Item -LiteralPath $build_dir -Force -Recurse
    Remove-Item -LiteralPath $prefix -Force -Recurse
}

$GlobalDefinitions = @{
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
        $definition = $GlobalDefinitions[$key]
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

    & cmake -B $build_dir_project -G Ninja -S $ProjectName `
        -DCMAKE_BUILD_TYPE="$config" `
        $defs
    & cmake --build $build_dir_project
    & cmake --install $build_dir_project --prefix $prefix
}

Build "Vulkan-Headers"
Build "Vulkan-Loader" @("VULKAN_HEADERS_INSTALL_DIR")
Build "Vulkan-Utility-Libraries" @("VULKAN_HEADERS_INSTALL_DIR")
Build "SPIRV-Headers"

$spirvHeaderDir = "$PSScriptRoot\SPIRV-Headers"
$spirvHeaderDir = $spirvHeaderDir -replace '\\', '/'
$definitions = @{
    "SPIRV-Headers_SOURCE_DIR" = $spirvHeaderDir
    SPIRV_WERROR = "OFF"
    SPIRV_SKIP_TESTS = "ON"
    SPIRV_SKIP_EXECUTABLES = "OFF"
}
Build "SPIRV-Tools" @() $definitions

$definitions = @{ RH_STANDALONE_PROJECT = "OFF" }
Build "robin-hood-hashing" @() $definitions

$definitions = @{
    MI_BUILD_STATIC = "ON"
    MI_BUILD_OBJECT = "OFF"
    MI_BUILD_SHARED = "OFF"
    MI_BUILD_TESTS = "OFF"
}
Build "mimalloc" @() $definitions

$definitions = @{
    ENABLE_OPT = "OFF"
}
Build "glslang" @() $definitions

Build "valijson" @() @{}

$definitions = @{
    CMAKE_POSITION_INDEPENDENT_CODE = "ON"
    JSONCPP_WITH_TESTS = "OFF"
    JSONCPP_WITH_POST_BUILD_UNITTEST = "OFF"
    JSONCPP_WITH_WARNING_AS_ERROR = "OFF"
    JSONCPP_WITH_PKGCONFIG_SUPPORT = "OFF"
}
Build "jsoncpp" @() $definitions

$definitions = @{
    VulkanHeaders_DIR = "$prefix\share\cmake\VulkanHeaders"
    VulkanUtilityLibraries_DIR = "$prefix\lib\cmake\VulkanUtilityLibraries"
    valijson_DIR = "$prefix\lib\cmake\valijson"
    jsoncpp_DIR = "$prefix\lib\cmake\jsoncpp"
}
Build "Vulkan-Profiles" @("VULKAN_HEADERS_INSTALL_DIR") $definitions

Build "Vulkan-ValidationLayers" @("VULKAN_HEADERS_INSTALL_DIR") @{}

# Note that this builds some projects _again_, only without
# installing.
# I could not find an option to re-use an already installed version,
# it looks like shaderc insists on sources.
$definitions = @{
    EFFCEE_BUILD_SAMPLES = "OFF"
    EFFCEE_BUILD_TESTING = "OFF"
    SHADERC_SKIP_TESTS = "ON"
    SHADERC_SKIP_EXAMPLES = "ON"
    SHADERC_ENABLE_WGSL_OUTPUT = "OFF"
    SKIP_GLSLANG_INSTALL = "ON"
    SKIP_SPIRV_TOOLS_INSTALL = "ON"
    SKIP_GOOGLETEST_INSTALL = "ON"
    SHADERC_GOOGLE_TEST_DIR = "$PSScriptRoot\googletest"
    SHADERC_SPIRV_TOOLS_DIR = "$PSScriptRoot\SPIRV-Tools"
    SHADERC_SPIRV_HEADERS_DIR = "$PSScriptRoot\SPIRV-Headers"
    SHADERC_GLSLANG_DIR = "$PSScriptRoot\glslang"
    SHADERC_ABSL_DIR = "$PSScriptRoot\abseil-cpp"
    SHADERC_RE2_DIR = "$PSScriptRoot\re2"
    SHADERC_EFFCEE_DIR = "$PSScriptRoot\effcee"
}
Build "shaderc" @() $definitions

$definitions = @{
    VMA_BUILD_SAMPLES = "ON"
}
$env:VULKAN_SDK = $prefix
Build "VulkanMemoryAllocator" @() $definitions
