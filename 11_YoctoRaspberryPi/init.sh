#!/bin/bash

# Get Poky
git clone -b thud git://git.yoctoproject.org/poky.git
cd poky

# Get the official Raspberry layer
git clone -b thud git://git.yoctoproject.org/meta-raspberrypi

# Get the Xenomai layer from Pierre FICHEUX
git clone https://bitbucket.org/pficheux/meta-xenomai

# Copy the desired configuration files
mkdir -p build/conf
cp ../*.conf build/conf

# Initialize the build environment
source ./oe-init-build-env build

# Build
bitbake core-image-minimal
