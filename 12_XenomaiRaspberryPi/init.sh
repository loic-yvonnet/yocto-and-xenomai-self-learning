#!/bin/bash

# Inspired by Real-Time Linux Testbench on Raspberry Pi 3 using Xenomai, part 4, by Gustav Johansson
# KTH Royal Institute of Technology
# School of Electrical Engineering and Computer Science
# Used also instructions from https://elinux.org/RPi_U-Boot
# License: LGPL-3.0

# Parse argument
if [ ! -z $1 ]
then
	linux_version=$1
else
	linux_version=4.9.51
fi

# Local variables
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
build_dir=${current_dir}/build/${linux_version}
image_dir=${build_dir}/image
rootfs_dir=${image_dir}/rootfs
boot_dir=${image_dir}/boot
linux_dir=linux-${linux_version}
linux_tar=${linux_dir}.tar.gz
linux_url=https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/snapshot/${linux_tar}
xeno_version=3.1
xeno_dir=xenomai-${xeno_version}
xeno_tar=${xeno_dir}.tar.bz2
xeno_url=https://xenomai.org/downloads/xenomai/stable/${xeno_tar}
ipipe_patch=ipipe-core-${linux_version}-arm-4.patch
ipipe_url=http://xenomai.org/downloads/ipipe/v4.x/arm/${ipipe_patch}
uboot_dir=u-boot
uboot_url=git://git.denx.de/${uboot_dir}.git
linaro_dir=gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
linaro_tar=${linaro_dir}.tar.xz
linaro_url=https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/${linaro_tar}
first_stage_bootloader=rpi_fsb
first_stage_bootloader_url=https://github.com/raspberrypi/firmware.git

# Build directory
mkdir -p ${build_dir}
cd ${build_dir}

# Deployment directory
mkdir -p ${rootfs_dir}
mkdir -p ${boot_dir}

# Acquire U-Boot
if [ ! -d ${uboot_dir} ]
then
	echo "Acquiring das U-Boot..."
	git clone ${uboot_url}
fi

# Acquire I-Pipe
if [ ! -f ${ipipe_patch} ]
then
	echo "Acquiring I-Pipe..."
	wget ${ipipe_url}
fi

# Acquire mainline kernel
if [ ! -d ${linux_dir} ]
then
	echo "Acquiring Kernel..."
	wget ${linux_url}
	tar xvzf ${linux_tar}
fi

# Acquire Xenomai
if [ ! -d ${xeno_dir} ]
then
	echo "Acquiring Xenomai..."
	wget ${xeno_url}
	tar xvjf ${xeno_tar}
fi

# Acquire first stage bootloader
if [ ! -d ${first_stage_bootloader} ]
then
	echo "Acquiring RPi board first stage bootloader..."
	git clone --depth=1 ${first_stage_bootloader_url} ${first_stage_bootloader}
	cp -r ${first_stage_bootloader}/boot/* ${boot_dir}
	cp ${current_dir}/config.txt ${boot_dir}
	cp ${current_dir}/cmdline.txt ${boot_dir}
fi

# Acquire the Linaro Cross-Compiler
if [ ! -d ${linaro_dir} ]
then
	echo "Acquiring the Linaro Cross-Compiler..."
	wget ${linaro_url}
	tar xf ${linaro_tar}
fi
export PATH=${build_dir}/${linaro_dir}/bin:${PATH}
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export USE_PRIVATE_LIBGCC=yes

# Apply I-Pipe
if [ ! -f .ipipe_already_applied ]
then
	cd ${linux_dir}
	echo "I-Pipe dry run..."
	patch -p1 --dry-run < ../${ipipe_patch}
	if [ $? -ne 0 ]
	then
		echo "Error: The I-Pipe patch may not be applied to the selected Linux kernel ${linux_version}."
		exit 1
	fi
	echo "Applying I-Pipe..."
	patch -p1 < ../${ipipe_patch}
	cd ..
	touch .ipipe_already_applied
fi

# Prepare the Xenomai kernel
if [ ! -f .xenomai_already_prepared ]
then
	echo "Preparing the Xenomai kernel..."
	cd ${xeno_dir}
	./scripts/prepare-kernel.sh --linux=${build_dir}/${linux_dir} --arch=arm --ipipe=${build_dir}/${ipipe_patch}
	if [ $? -ne 0 ]
	then
		echo "Error: Failed to prepare the Xenomai kernel on top of the Linux mainline kernel."
		exit 1
	fi
	cd ..
	touch .xenomai_already_prepared
fi

# Configure the kernel
cd ${linux_dir}
if [ ! -f ${current_dir}/defconfig_${linux_version} ]
then
	echo "Configuring the kernel..."
	defconfig_path=`find . -name multi_v7_defconfig`
	cp ${defconfig_path} .
	make multi_v7_defconfig
	make menuconfig
	if [ $? -ne 0 ]
	then
		echo "Error: Failed to configure the Linux kernel."
		exit 1
	fi
	cp .config ${current_dir}/defconfig_${linux_version}
else
	cp ${current_dir}/defconfig_${linux_version} .config
fi

# Compile the Linux kernel
nb_cpus=`lscpu -p | grep -v '#' | wc -l`
if [ ! -f .linux_kernel_already_compiled ]
then
	echo "Compiling the Linux kernel..."
	make zImage modules dtbs -j${nb_cpus}
	if [ $? -ne 0 ]
	then
		echo "Error: Failed to compile the patched mainline Linux kernel ${linux_version} with ${ipipe_patch} for Xenomai ${xeno_version}."
		exit 1
	fi
	touch .linux_kernel_already_compiled
fi

# Install the Linux kernel
if [ ! -f .linux_kernel_already_installed ]
then
	echo "Installing the Linux kernel..."
	export INSTALL_MOD_PATH=${rootfs_dir}
	make modules_install
	if [ $? -ne 0 ]
	then
		echo "Error: Failed to install the kernel modules."
		exit 1
	fi
	cp arch/arm/boot/dts/bcm*.dtb ${boot_dir}
	cp arch/arm/boot/zImage ${boot_dir}
	touch .linux_kernel_already_installed
fi

# Configure, compile and install Xenomai Cobalt
cd ${build_dir}
if [ ! -f .xenomai_already_installed ]
then
	cd ${xeno_dir}
	echo "Bootstrapping Xenomai..."
	./scripts/bootstrap
	if [ $? -ne 0 ]
	then
		echo "Error: Failed to bootstrap Xenomai."
		exit 1
	fi
	export CFLAGS="-march=armv7-a -mfloat-abi=hard -mfpu=neon -ffast-math -D_GNU_SOURCE"
	export LDFLAGS="-march=armv7-a -mfloat-abi=hard -mfpu=neon -ffast-math"
	export DESTDIR=${rootfs_dir}
	mkdir -p build
	cd build
	echo "Configuring Xenomai..."
	../configure --enable-smp --host=arm-linux-gnueabihf --with-core=cobalt
	if [ $? -ne 0 ]
	then
		echo "Error: Failed to configure Xenomai."
		exit 1
	fi
	echo "Compiling and installing Xenomai..."
	make install
	if [ $? -ne 0 ]
	then
		echo "Error: Failed to compile or install Xenomai."
		echo "Trying to patch lib/cobalt/wrappers.c..."
		sed -i "s@return sendmmsg(fd, msgvec, vlen, flags);@return 0; //return sendmmsg(fd, msgvec, vlen, flags);@g" \
			${build_dir}/${xeno_dir}/lib/cobalt/wrappers.c
		if [ $? -ne 0 ]
		then
			echo "Error: Failed to patch lib/cobalt/wrappers.c."
			exit 1
		fi
		make install
	        if [ $? -ne 0 ]
        	then
			echo "Error: Second attempt to compile Xenomai failed."
			exit 1
		fi
	fi
	cd ${build_dir}
	touch .xenomai_already_installed
fi

# U-Boot
if [ ! -f .uboot_already_installed ]
then
	# Prepare U-Boot
	cd ${build_dir}/${uboot_dir}
	echo "Preparing das U-Boot..."
	make rpi_3_32b_defconfig
	if [ $? -ne 0 ]
	then
		echo "Error: Failed to prepare das U-Boot."
		exit 1
	fi

	# Compile U-Boot
	echo "Compiling das U-Boot..."
	make -j${nb_cpus}
	if [ $? -ne 0 ]
	then
		echo "Error: Failed to compile das U-Boot."
		exit 1
	fi

	# Compile the Boot instructions
	echo "Compiling default boot instructions..."
	cp ${current_dir}/boot.scr .
	./tools/mkimage -A arm -O linux -T script -C none -n boot.scr -d boot.scr boot.scr.uimg

	# Install U-Boot
	echo "Installing das U-Boot..."
	cp u-boot.bin ${boot_dir}
	cp boot.scr.uimg ${boot_dir}

	cd ${build_dir}
	touch .uboot_already_installed
fi

# Conclusion
echo "Done."
echo "Now, you may deploy to some RPi SD card. Assuming your SD card is /dev/sdb:"
echo "sudo mkdir -p /media/rpi/boot"
echo "sudo mkdir -p /media/rpi/rootfs"
echo "sudo mount /dev/sdb1 /media/rpi/boot"
echo "sudo mount /dev/sdb2 /media/rpi/rootfs"
echo "sudo cp -r ${boot_dir}/* /media/rpi/boot"
echo "sudo cp -r ${rootfs_dir}/* /media/rpi/rootfs"
echo "sudo umount /dev/sdb1 /media/rpi/boot"
echo "sudo umount /dev/sdb2 /media/rpi/rootfs"
echo ""
echo "Please note that it is known to *not* boot successfully (all was done for nothing)."
