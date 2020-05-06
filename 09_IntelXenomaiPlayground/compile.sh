#!/bin/bash

echo "It should be run from QEMU"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/xenomai/lib
export PATH=$PATH:/usr/xenomai/bin

mkdir -p build

cd build

cmake -DCMAKE_BUILD_TYPE=Debug ..

make -j4
