#!/bin/bash

if [ -z $1 ]
then
	echo "You must specify the SD card device path (e.g. /dev/sdb)."
	exit 1
fi

cd build/tmp/deploy/images/raspberrypi3
if [ $? -ne 0 ]
then
	echo "You must call init.sh first."
	exit 1
fi

echo "Burning to the SD card: $1..."
sudo dd if=core-image-minimal-raspberrypi3.rpi-sdimg of=$1 status=progress
