#!/bin/bash

if [ -d build ]
then
    echo "Already initialized"
    exit 1 
fi

# Install the Yocto dependencies
sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
     pylint3 xterm

# Clone the Poky repo (contains the Yocto toolchain)
git clone git://git.yoctoproject.org/poky

# Initialize the build directory, environment variable, and the PATH
source poky/oe-init-build-env

# Build a minimal embedded x86-64 system that can be emulated thanks to QEMU
bitbake core-image-minimal

# Add CMake to the Yocto toolchain
echo "" >> conf/local.conf
echo "#" >> conf/local.conf
echo "# Yocto CMake Toolchain" >> conf/local.conf
echo "#" >> conf/local.conf
echo "TOOLCHAIN_HOST_TASK += \"nativesdk-cmake\"" >>  conf/local.conf

# Build the CMake toolchain for the target embedded OS
bitbake core-image-minimal -c populate_sdk

# Build the C++ hello world program for the target embedded OS
bitbake-layers add-layer ../recipes-hellocpp
bitbake recipes-hellocpp

# Make sure that the hello world package will be deployed to embedded OS image
echo "" >> conf/local.conf
echo "#" >> conf/local.conf
echo "# Yocto Image Install" >> conf/local.conf
echo "#" >> conf/local.conf
echo "IMAGE_INSTALL_append = \"recipes-hellocpp\"" >>  conf/local.conf

# Add the hello world package to the embedded OS
bitbake core-image-minimal
