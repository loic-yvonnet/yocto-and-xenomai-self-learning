#!/bin/bash

echo "This script is aimed to be run from QEMU"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/xenomai/lib
export PATH=$PATH:/usr/xenomai/bin

# Reference: https://github.com/intel/xenomai/issues/3
sysctl -w kernel.sched_rt_runtime_us=-1

latency -p 1000
