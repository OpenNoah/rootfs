#!/bin/bash -ex
TOP=$PWD
KERNEL=${KERNEL:-$PWD/linux}

linux_ver="$(cd "$KERNEL"; git rev-parse --short HEAD)"
kernel_ver="$(ls -1 build/rootfs/lib/modules/)"
release="${kernel_ver}-${linux_ver}"

tar acf rootfs-${release}.tar.xz -C build/rootfs .

cp $KERNEL/arch/mips/boot/uImage.bin uImage-${release}
