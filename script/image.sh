#! /bin/bash
set -ex

rm -rf /output/*

cp /root/linux-source-$KERNEL_SOURCE_VERSION/vmlinux /output/vmlinux
cp /root/linux-source-$KERNEL_SOURCE_VERSION/.config /output/config

truncate -s 512M /output/image.ext4
mkfs.ext4 /output/image.ext4

mount /output/image.ext4 /rootfs
debootstrap --include openssh-server,nano $DEBIAN_VERSION /rootfs http://deb.debian.org/debian/
mount --bind / /rootfs/mnt

chroot /rootfs /bin/bash /mnt/script/provision.sh

umount /rootfs/mnt || true
umount /rootfs || true

cd /output
tar czvf debian-$DEBIAN_VERSION.tar.gz image.ext4 vmlinux config
cd /