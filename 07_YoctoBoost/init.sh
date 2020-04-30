#!/bin/bash

# Check whether there is anything at all required
if [ -d build ]
then
    echo "Already initialized"
    exit 1 
fi

# Install the Yocto dependencies
echo "---------------------------------------------------------------------------------------------"
echo "Install the Yocto dependencies"
sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
     pylint3 xterm

# Clone the Poky repo (contains the Yocto toolchain)
echo "---------------------------------------------------------------------------------------------"
echo "Clone the poky repo"
if [ -d poky ]
then
    echo "poky already cloned"
else
    git clone git://git.yoctoproject.org/poky
fi

# Initialize the build directory, environment variable, and the PATH
echo "---------------------------------------------------------------------------------------------"
echo "Initialize the build directory"
source poky/oe-init-build-env

# Build a minimal embedded x86-64 system that can be emulated thanks to QEMU
echo "---------------------------------------------------------------------------------------------"
echo "Initial build"
bitbake core-image-minimal

# Add CMake to the Yocto toolchain
echo "---------------------------------------------------------------------------------------------"
echo "Add CMake to conf/local.conf"
echo "" >> conf/local.conf
echo "#" >> conf/local.conf
echo "# Yocto CMake Toolchain" >> conf/local.conf
echo "#" >> conf/local.conf
echo "TOOLCHAIN_HOST_TASK += \"nativesdk-cmake\"" >>  conf/local.conf

# Build the CMake toolchain for the target embedded OS
echo "---------------------------------------------------------------------------------------------"
echo "Build the SDK with CMake"
bitbake core-image-minimal -c populate_sdk

# Build the C++ program for the target embedded OS
echo "---------------------------------------------------------------------------------------------"
echo "Add the Yocto Boost layer and build its recipe"
bitbake-layers add-layer ../meta-yoctoboost
bitbake recipes-yoctoboost

# Make sure that the hello world package will be deployed to embedded OS image
echo "---------------------------------------------------------------------------------------------"
echo "Add the Yocto Boost executable as an install dependencies in conf/local.conf"
echo "" >> conf/local.conf
echo "#" >> conf/local.conf
echo "# Yocto Image Install" >> conf/local.conf
echo "#" >> conf/local.conf
echo "IMAGE_INSTALL_append = \"recipes-yoctoboost\"" >>  conf/local.conf

# Add the hello world package to the embedded OS
echo "---------------------------------------------------------------------------------------------"
echo "Deploy the Yocto Boost executable"
bitbake core-image-minimal
