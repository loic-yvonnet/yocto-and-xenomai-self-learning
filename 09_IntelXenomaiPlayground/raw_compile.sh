#!/bin/bash

echo "It should be run from QEMU in a directory with a valid Xenomai main.c file"

gcc `xeno-config --posix --cflags` `xeno-config --posix --ldflags` main.c
