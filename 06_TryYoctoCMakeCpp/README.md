# Cross-compiling a simple C++ Hello World with CMake with Yocto

It actually works and it uses modern (at the time of writing) CMake 3.16 and GCC 9.3. This is very good news, because it means that Yocto keeps up with latest toolchains. It also means that GCC 10, which is going to be a fantastic release with many C++20 features, will be included soon. C++ Concepts are by themselves a good reason to switch to C++20.

Besides, it seems to link with libstdc++, which means modern STL support as well. Yocto is pretty cool once you start groking things.

It is time to try to include external dependencies, e.g. Boost.
