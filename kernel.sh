#!/bin/bash -ex
JOBS=${JOBS:-12}

TOP=$PWD
KERNEL=${KERNEL:-$TOP/linux}
ROOTFS=$TOP/build/rootfs

kargs="-j$JOBS ARCH=mips CROSS_COMPILE=mipsel-linux-"

cd $KERNEL
if [ -n "$DEFCONFIG" ]; then
	make $kargs $DEFCONFIG
fi

sed -i "s/CONFIG_INITRAMFS_SOURCE=.*/CONFIG_INITRAMFS_SOURCE=\"${ROOTFS//\//\\\/}\"/" .config

make $kargs uImage
make $kargs modules
make $kargs modules_install INSTALL_MOD_PATH=$ROOTFS
