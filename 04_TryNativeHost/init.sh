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

# Create a new application layer to host the hello world program
bitbake-layers create-layer meta-helloworld
bitbake-layers add-layer meta-helloworld

# Clean up the application layer
rm -rf meta-helloworld/recipes-example

# Create a new recipes in this application layer to host the hello world program
mkdir meta-helloworld/recipes-helloworld/helloworld/files
cp ../helloworld.c meta-helloworld/recipes-helloworld/helloworld/files/
cp ../recipes-helloworld.bb meta-helloworld/recipes-helloworld/helloworld/

# Build the hello world program for the target embedded OS
bitbake recipes-helloworld

# Make sure that the hello world package will be deployed to embedded OS image
echo "" >> conf/local.conf
echo "#" >> conf/local.conf
echo "# Yocto Image Install" >> conf/local.conf
echo "#" >> conf/local.conf
echo "IMAGE_INSTALL_append = \" recipes-helloworld\"" >>  conf/local.conf

# Add the hello world package to the embedded OS
bitbake core-image-minimal
