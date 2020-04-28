#!/bin/bash

docker run --name yocto-dev --rm -it \
	-v $PWD/workdir:/workdir \
	--device=/dev/kvm:/dev/kvm \
	--device=/dev/net/tun:/dev/net/run \
	--cap-add NET_ADMIN \
	crops/poky:ubuntu-18.04 --workdir=/workdir
