#!/bin/bash

docker run --rm -it -v $PWD/yocto-outputs:/workdir crops/poky --workdir=/workdir
