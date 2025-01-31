$version = "vulkan-sdk-1.4.304"
$build_dir = "$PSScriptRoot\build"
$prefix = "$PSScriptRoot\install"

Write-Host "Building $version in $build_dir"

cmake -B $build_dir -S Vulkan-Headers
cmake --install $build_dir --prefix $prefix