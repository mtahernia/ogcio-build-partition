#!/bin/bash

set -ex

ROOT_FOLDER=image


for x in /dev /sys /proc; do sudo mount -o bind $x ${ROOT_FOLDER}/$x; done


sudo cp *.deb ${ROOT_FOLDER}/
sudo chroot ${ROOT_FOLDER} bash -c "dpkg -i box.deb"
sudo chroot ${ROOT_FOLDER} bash -c "dpkg -i bats-code-*.deb"
sudo chroot ${ROOT_FOLDER} bash -c "dpkg -i fsm-*.deb"
# Edit setup.sh if needed
sudo chroot ${ROOT_FOLDER} bash -c "/home/nclab/setup.sh"


sudo chroot ${ROOT_FOLDER} bash -c "cat << EOF >> /etc/network/interfaces

allow-hotplug enp5s0
iface enp5s0 inet static
    address 10.32.0.23/25
EOF"


sudo install -D QCA988X/* -t ${ROOT_FOLDER}/lib/firmware/ath10k/QCA988X/hw2.0/


for x in /dev /sys /proc; do sudo umount ${ROOT_FOLDER}/$x; done
