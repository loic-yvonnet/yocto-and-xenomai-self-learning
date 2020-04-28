# Sadly it works from the host

It could mean that running Yocto from Docker is not entirely supported at the time of writing.

Anyway, I already have a GNU/Linux host, so I am not blocked. But I prefer to keep my build and execution environments apart from my host, because:
* I work on various projects, which have various prerequisites (some require GCC 7, some require GCC 10, some require CMake 3.16, NPM, etc.).
* I upgrade every 2 years or so my OS, and Docker enables me to keep a stable work environment, along time, across machines and OS.
