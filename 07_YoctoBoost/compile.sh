#!/bin/bash

which bitbake > /dev/null 2>&1
if [ $? != 0 ]
then
    source poky/oe-init-build-env > /dev/null
fi

bitbake core-image-minimal
