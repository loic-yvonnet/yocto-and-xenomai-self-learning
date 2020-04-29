# It works from the host

Following the instructions from the Yocto Project quick start guide is simple and works like a charm.

I already have a GNU/Linux host, so I am not blocked. But I prefer to keep my build and execution environments apart from my host, because:
* I work on various projects, which have various prerequisites (some require GCC 7, some require GCC 10, some require CMake 3.16, NPM, etc.).
* I upgrade every 2 years or so my OS, and Docker enables me to keep a stable work environment, along time, across machines and OS.

In the folder number 05, there is finally a solution to use Docker to run the whole suite of Yocto tools.
