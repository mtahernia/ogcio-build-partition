#!/bin/bash

if [ $# -le 1 ]; then
        echo "Usage:    ./2_part_disk.sh image_folder device";
        exit 0
fi

set -ex

ROOT_FOLDER=$1
DEV=$2


## Step 3: Partition disk and copy files

cat << EOF | sudo sfdisk ${DEV}
label: gpt
device: /dev/sda
unit: sectors
first-lba: 2048

/dev/sda1 : start=        2048, size=      204800, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B, uuid=AAAD878D-10CE-4A21-BE32-73FD855AA7CF
/dev/sda2 : start=      206848, size=      512000, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=7F4F4CEC-681E-4833-A466-B991725AD442
/dev/sda3 : start=      718848, type=	   0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=74E3140F-623B-4F24-964B-5C8DADF8DE69
EOF


sudo mkfs.vfat ${DEV}1 # 37D4-A065
sudo mlabel -i ${DEV}1 -N 37D4A065
sudo mkfs.ext4 ${DEV}2 -U afc9cecd-f025-4ee4-ba7d-03afbb813558 -F
sudo mkfs.ext4 ${DEV}3 -U ebb5187a-1c90-4f0e-ae24-b313318147a3 -F


sudo mkdir -p /mnt          && sudo mount ${DEV}3 /mnt
sudo mkdir -p /mnt/boot/    && sudo mount ${DEV}2 /mnt/boot
sudo mkdir -p /mnt/boot/efi && sudo mount ${DEV}1 /mnt/boot/efi/
sudo cp -rp ${ROOT_FOLDER}/* /mnt


## Step 4: Install bootloader

for x in /dev /sys /proc; do sudo mount -o bind $x /mnt/$x; done
sudo chroot /mnt bash -c "grub-install ${DEV} --recheck -v"
sudo chroot /mnt bash -c "update-grub"
sudo chroot /mnt bash -c "cat << EOF > /etc/fstab
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
UUID=37D4-A065                            /boot/efi       vfat    umask=0077        0       1
UUID=afc9cecd-f025-4ee4-ba7d-03afbb813558 /boot           ext4    errors=remount-ro 0       1
UUID=ebb5187a-1c90-4f0e-ae24-b313318147a3 /               ext4    errors=remount-ro 0       1
EOF"
for x in /dev /sys /proc; do sudo umount /mnt/$x; done


sudo umount ${DEV}1 ${DEV}2 ${DEV}3
sync
echo "Finished"
