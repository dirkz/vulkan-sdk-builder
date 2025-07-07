# Build your own Vulkan SDK

With powershell, because, I'm starting on windows, and why not?

I see that both
[macOS](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.4)
and
[linux](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.4)
have it, too, that just may cover all of the platforms you'd want to develop vulkan applications on.

Anyways, everything is built. Headers _look_ complete, binaries can get
invoked and queried for the versions. This now needs a thorough test, like following
the [Vulkan Tutorial](https://docs.vulkan.org/tutorial/latest/00_Introduction.html)
with this as SDK. Also looks good so far. Instance creation, querying for layers and extensions.

Even with the partial redundant builds mentioned in the script, it's just a couple
of minutes on a reasonable development machine.
You may not be able to do anything else, but that may be `ninja` hogging every
single core. Or my machine not being beefy enough.

Updating to another SDK looks like a little bit of work, mostly checking out the
corresponding tag, and glancing into some `known_good.json` files for pointers about
non-vulkan dependencies. Should be done in less than 1h.

## Environment

Don't forget to point `VULKAN_SDK` and `VK_LAYER_PATH` to the right directories, e.g.:

```
VULKAN_SDK = C:\Vulkan\1.4.313
VK_LAYER_PATH = %VULKAN_SDK%\bin
```

Have `clang-format` in your PATH if you want to have your Vulkan-Hpp headers formatted.

## Updating

[SPIRV-Tools\DEPS](SPIRV-Tools\DEPS) has some hashes that are needed,
those must match what the submodules are checked out to.
All in all, typically you update projects to a matching (and existing) tag of the vulkan SDK version
you want to build, e.g. `vulkan-sdk-1.4.313` or something similar, like `v1.4.313`.

At least Vulkan-Hpp and slang have their own set of submodules, so after having checked out the version,
you'll have to `git submodule update --init --recursive` to get them right. And yes, that means that some projects
are built from source more than once.

After building, Vulkan-Hpp has some files created that are not ignored. `git reset --hard` or even `git clean -xf`
may come in handy.