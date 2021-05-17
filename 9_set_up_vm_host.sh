#!/bin/bash

if [ $# -le 0 ]; then
        echo "Usage:    ./1b_build_bats_box.sh image_folder";
        exit 0
fi

set -ex

ROOT_FOLDER=$1


for x in /dev /sys /proc; do sudo mount -o bind $x ${ROOT_FOLDER}/$x; done

cp -p watchdog-vm.deb ${ROOT_FOLDER}/home/nclab/
sudo chroot ${ROOT_FOLDER} bash -c "dpkg -i /home/nclab/watchdog-vm.deb"
sudo chroot ${ROOT_FOLDER} bash -c "/home/nclab/watchdog-vm/host/setup.sh"

cp -rp qemu/ ${ROOT_FOLDER}/home/nclab/
sudo chroot ${ROOT_FOLDER} bash -c "/home/nclab/qemu/setup.sh"


for x in /dev /sys /proc; do sudo umount ${ROOT_FOLDER}/$x; done
