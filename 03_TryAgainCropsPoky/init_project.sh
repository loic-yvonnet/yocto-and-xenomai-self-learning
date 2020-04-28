#!/bin/bash

docker pull crops/poky:ubuntu-18.04

mkdir -p $PWD/workdir
cd $PWD/workdir

git clone git://git.yoctoproject.org/poky

