# Start from an older version of Debian to get an older version of GCC.
# This is due to the old version of the Linux kernel which may not be built
# with a version of GCC greater than 5.
FROM debian:8

# Arguments to choose the version of the Linux kernel and the Xenomai version
ARG kernel_version=3.18.20
ARG kernel_tar=linux-${kernel_version}.tar.xz
ARG kernel_tar_url=https://www.kernel.org/pub/linux/kernel/v3.x/${kernel_tar}
ARG xenomai_patch=ipipe-core-${kernel_version}-x86-9.patch
ARG xenomai_patch_url=https://xenomai.org/downloads/ipipe/v3.x/x86/${xenomai_patch}
ARG xenomai_version=v3.0.x

# Make a build directory
RUN mkdir /tmp/build-xenomai
WORKDIR /tmp/build-xenomai

# Copy the Linux kernel configuration file (otherwise make [ARCH=i386] menuconfig)
COPY ./LinuxKernelConfig/.config /tmp/build-xenomai/

# Mount a volume pointing to the host
RUN mkdir /tmp/host
VOLUME /tmp/host

# Install dependencies and build Xenomai Cobalt and a Linux kernel
RUN apt-get update && \
    # Default Debian development environment
    apt-get install -y  apt-transport-https ca-certificates gnupg \
                        software-properties-common libreadline6-dev \
                        build-essential bc python bison flex libelf-dev \
                        libssl-dev libncurses-dev libnl-3-dev wget curl \
                        git tar unzip vim && \
    apt-get update && \
    # Clean up
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    # Download the Xenomai patch for the Linux kernel
    wget ${xenomai_patch_url} && \
    mv ${xenomai_patch} patch && \
    # Download the Linux kernel
    wget ${kernel_tar_url} && \
    tar fxJ ${kernel_tar} && \
    rm ${kernel_tar} && \
    mv linux-${kernel_version} linux && \
    # Clone the Xenomai git repo and checkout the desired stable branch
    git clone https://gitlab.denx.de/Xenomai/xenomai.git && \
    cd xenomai && \
    git checkout stable/${xenomai_version} && \
    # Patch the Linux kernel for Xenomai Cobalt
    cd /tmp/build-xenomai/linux && \
    /tmp/build-xenomai/xenomai/scripts/prepare-kernel.sh \
        --arch=x86 \
        --ipipe=/tmp/build-xenomai/patch && \
    # Move the configuration file to the Linux kernel build directory
    mv /tmp/build-xenomai/.config /tmp/build-xenomai/linux/.config && \
    # Remove some warnings
    sed -i s/-Werror-implicit-function-declaration//g Makefile && \
    # Build a compatible Linux kernel with Xenomai Cobalt
    make [ARCH=i386] bzImage modules && \
    # Build the Xenomai x86 libraries
    mkdir /tmp/build-xenomai/build && \
    cd /tmp/build-xenomai/build && \
    /tmp/build-xenomai/xenomai/configure \
        --with-core=cobalt \
        --enable-smp \
        --enable-pshared \
        --host=i686-linux CFLAGS="-m32 -O2" LDFLAGS="-m32" && \
    make install
