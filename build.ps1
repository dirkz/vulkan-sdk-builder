$version = "vulkan-sdk-1.4.304"
$build_dir = "$PSScriptRoot\build"
$prefix = "$PSScriptRoot\install"

Write-Host "Building $version in $build_dir"

$project = "Vulkan-Headers"
$build_dir_project = "$build_dir\$project"
cmake -B $build_dir_project -S $project
cmake --install $build_dir_project --prefix $prefix