#!/bin/bash -ex
busybox_url="https://busybox.net/downloads/busybox-1.35.0.tar.bz2"

JOBS=${JOBS:-12}

TOP=$PWD
TOOLCHAIN=$(dirname $(dirname $(which mipsel-linux-gcc)))

rm -rf build
mkdir -p build
cd build

curl "$busybox_url" | tar jxf -
ln -sfr busybox-* busybox
cat $TOP/busybox_defconfig > busybox/.config

mkdir -p rootfs

pushd busybox
make -j$JOBS
make install CONFIG_PREFIX=$PWD/../rootfs
popd

# Shared libraries for busybox
mkdir -p rootfs/lib
cp -a $TOOLCHAIN/mipsel-linux/lib/libc.so* \
      $TOOLCHAIN/mipsel-linux/lib/libm.so* \
      $TOOLCHAIN/mipsel-linux/lib/libresolv.so* \
      $TOOLCHAIN/mipsel-linux/lib/ld.so* \
      rootfs/lib/
mipsel-linux-strip rootfs/lib/*.so.*

# Essential directories and files
pushd rootfs
mkdir -p etc dev sys proc tmp mnt/mmc mnt/root
popd

sudo mknod rootfs/dev/console c 5 1
sudo mknod rootfs/dev/null c 1 3
