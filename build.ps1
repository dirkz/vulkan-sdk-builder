$version = "vulkan-sdk-1.4.304"
$build_dir = "$PSScriptRoot\build"
$prefix = "$PSScriptRoot\install"
$config = "Debug"

Write-Host "Building $version in $build_dir"

$project = "Vulkan-Headers"
$build_dir_project = "$build_dir\$project"
& cmake -B $build_dir_project -S $project
& cmake --install $build_dir_project --prefix $prefix

$VULKAN_HEADERS_INSTALL_DIR = $prefix

$project = "Vulkan-Loader"
$build_dir_project = "$build_dir\$project"
& cmake -B $build_dir_project -S $project `
    -D VULKAN_HEADERS_INSTALL_DIR=$VULKAN_HEADERS_INSTALL_DIR
& cmake --build $build_dir_project --config $config
& cmake --install $build_dir_project --prefix $prefix --config $config
