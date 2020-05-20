#!/bin/bash

which bitbake > /dev/null 2>&1
if [ $? != 0 ]
then
    cd xenomai/snapshots/manifest_1
    source poky/oe-init-build-env > /dev/null
fi

bitbake -k core-image-xfce-sdk -c populate_sdk
