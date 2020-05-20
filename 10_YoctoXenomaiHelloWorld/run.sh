#!/bin/bash

cd xenomai/snapshots/manifest_1

source poky/oe-init-build-env

runqemu intel-corei7-64 qemuparams="-m 2048 -smp 4" slirp nographic
