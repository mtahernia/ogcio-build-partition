#!/bin/bash

if [ $# -le 0 ]; then
        echo "Usage:    ./1b_build_bats_box.sh image_folder";
        exit 0
fi

set -ex

ROOT_FOLDER=$1


for x in /dev /sys /proc; do sudo mount -o bind $x ${ROOT_FOLDER}/$x; done

cp -p *.deb ${ROOT_FOLDER}/home/nclab/
sudo chroot ${ROOT_FOLDER} bash -c "dpkg -i /home/nclab/box.deb"
sudo chroot ${ROOT_FOLDER} bash -c "dpkg -i /home/nclab/bats-code-*.deb"
sudo chroot ${ROOT_FOLDER} bash -c "dpkg -i /home/nclab/fsm-*.deb"

# update nodejs to v12
sudo chroot ${ROOT_FOLDER} bash -c "apt update && apt install -y curl"
sudo chroot ${ROOT_FOLDER} bash -c "apt purge -y nodejs"
sudo chroot ${ROOT_FOLDER} bash -c "curl -sL https://deb.nodesource.com/setup_12.x | bash -"
sudo chroot ${ROOT_FOLDER} bash -c "apt install -y nodejs"
sudo chroot ${ROOT_FOLDER} bash -c "npm i -g npm@latest"

# Edit setup.sh if needed
sudo chroot ${ROOT_FOLDER} bash -c "/home/nclab/setup.sh"


sudo chroot ${ROOT_FOLDER} bash -c "cat << EOF >> /etc/network/interfaces

allow-hotplug enp5s0
iface enp5s0 inet static
    address 10.32.0.23/25
EOF"


sudo install -D QCA988X/* -t ${ROOT_FOLDER}/lib/firmware/ath10k/QCA988X/hw2.0/


for x in /dev /sys /proc; do sudo umount ${ROOT_FOLDER}/$x; done
