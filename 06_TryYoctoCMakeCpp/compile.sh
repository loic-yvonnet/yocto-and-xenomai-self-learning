#!/bin/bash

source poky/oe-init-build-env > /dev/null

bitbake core-image-minimal
