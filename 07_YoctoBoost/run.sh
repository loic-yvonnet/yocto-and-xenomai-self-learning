#!/bin/bash

which runqemu > /dev/null 2>&1
if [ $? != 0 ]
then
    source poky/oe-init-build-env > /dev/null
fi

echo qemuarm64 login is root, no password required.
echo Run ./stop.sh from the host in another terminal window to stop the emulator.
echo The custom programs are installed in /usr/bin. For example /usr/bin/yoctoboost.
sleep 1
runqemu qemuarm64 core-image-minimal qemuparams="-m 256" slirp nographic
