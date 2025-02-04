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
VULKAN_SDK = C:\Vulkan\1.4.304
VK_LAYER_PATH = %VULKAN_SDK%\bin
```