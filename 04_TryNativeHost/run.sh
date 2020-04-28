#!/bin/bash

echo qemux86-64 login is root, no password required
echo run ./stop.sh from the host in another terminal window to stop the emulator
source ./poky/oe-init-build-env > /dev/null
runqemu qemux86-64 core-image-minimal qemuparams="-m 256" slirp nographic
