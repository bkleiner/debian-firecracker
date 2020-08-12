#! /bin/bash
set -ex

dpkg -i /mnt/root/linux*.deb

echo "debian-$DEBIAN_VERSION" > /etc/hostname
passwd -d root
mkdir /etc/systemd/system/serial-getty@ttyS0.service.d/
cat <<EOF > /etc/systemd/system/serial-getty@ttyS0.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root -o '-p -- \\u' --keep-baud 115200,38400,9600 %I $TERM
EOF

cat <<EOF > /etc/network/interfaces.d/eth0
auto eth0
allow-hotplug eth0
iface eth0 inet static
address 192.168.99.2/24
gateway 192.168.99.1
EOF