#!/bin/bash

docker run --name yocto-dev --rm -it \
	-v $PWD/workdir:/workdir \
	crops/poky:ubuntu-18.04 --workdir=/workdir
