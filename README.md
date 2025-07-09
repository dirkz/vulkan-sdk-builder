# Build your own Vulkan SDK

... with powershell
([macOS](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.4),
[linux](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.4)).

## Environment

Don't forget to point `VULKAN_SDK` and `VK_LAYER_PATH` to the right directories, e.g.:

```
VULKAN_SDK = C:\Vulkan\1.4.313
VK_LAYER_PATH = %VULKAN_SDK%\bin
```

Have [clang-format](https://github.com/dirkz/build-clang) in your PATH
if you want to have your [Vulkan-Hpp](https://github.com/KhronosGroup/Vulkan-Hpp) headers formatted.

## Updating

[SPIRV-Tools/DEPS](SPIRV-Tools/DEPS) has some hashes that are needed,
those must match what the submodules are checked out to.
All in all, typically you update projects to a matching (and existing) tag of the vulkan SDK version
you want to build, e.g. `vulkan-sdk-1.4.313` or something similar, like `v1.4.313`.

At least Vulkan-Hpp and slang have their own set of submodules, so after having checked out the version,
you'll have to `git submodule update --init --recursive` to get them right. And yes, that means that some projects
are built from source more than once.

Otherwise, look for `known_good.json` files once you have repos up-to-date for more pointers.

After building, Vulkan-Hpp has some files created that are not ignored. `git reset --hard` or even `git clean -xf`
may come in handy.