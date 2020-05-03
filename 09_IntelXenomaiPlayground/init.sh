#!/bin/bash

# Install the Go language if required
echo "------------------------------------------------------------------------------------------------"
echo "Install Go"
go version > /dev/null 2>&1
if [ $? != 0 ]
then
    wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.14.2.linux-amd64.tar.gz
    echo "" >> $HOME/.profile
    echo "export PATH=\$PATH:/usr/local/go/bin" >> $HOME/.profile
    if [ -f $HOME/.zshrc ]
    then
        echo "" >> $HOME/.zshrc
        echo "export PATH=\$PATH:/usr/local/go/bin" >> $HOME/.zshrc
    fi
    PATH=$PATH:/usr/local/go/bin
    rm go1.14.2.linux-amd64.tar.gz
else
    echo "Go already installed"
    go version
fi

# Install the Yocto dependencies
echo "------------------------------------------------------------------------------------------------"
echo "Install Yocto dependencies"
sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
     pylint3 xterm

# Clone the Intel Xenomai toolchain
echo "------------------------------------------------------------------------------------------------"
echo "Clone Intel Xenomai"
if [ -d xenomai ]
then
    echo "Intel Xenomai already cloned"
else
    git clone git@github.com:intel/xenomai.git
    cd xenomai
    chmod 755 download.sh
    echo "Install Intel Xenomai"
    ./download.sh
    cd snapshots/manifest_1/
    source poky/oe-init-build-env build
    bitbake -k core-image-xfce-sdk
fi
