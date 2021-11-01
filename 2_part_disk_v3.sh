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
unit: sectors
first-lba: 2048

/dev/sdb1 : start=        2048, size=       40960, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=BDDD3B41-D482-0E44-8847-F4920B09E3FC
/dev/sdb2 : start=       43008, size=      409600, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=170E3324-1061-4845-B1A9-A504EC77F5C6
/dev/sdb3 : start=      452608, size=    25165824, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=312247BA-A16E-C44E-9124-197E83599C19
/dev/sdb4 : start=    25618432, size=     5242880, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=13E06851-DEA2-8C4F-9338-1CDBACA9625E
EOF


sudo mkfs.vfat ${DEV}1 # 37D4-A065
sudo mlabel -i ${DEV}1 -N 37D4A065
sudo mkfs.ext4 ${DEV}2 -U afc9cecd-f025-4ee4-ba7d-03afbb813558 -F
sudo mkfs.ext4 ${DEV}3 -U ebb5187a-1c90-4f0e-ae24-b313318147a3 -F
sudo mkfs.ext4 ${DEV}4 -U b643621e-1958-4cd0-a1f2-a592f4770b4e -F


sudo mkdir -p /mnt          && sudo mount ${DEV}3 /mnt
sudo mkdir -p /mnt/boot/    && sudo mount ${DEV}2 /mnt/boot
sudo mkdir -p /mnt/boot/efi && sudo mount ${DEV}1 /mnt/boot/efi/
sudo mkdir -p /mnt/var      && sudo mount ${DEV}4 /mnt/var
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
UUID=b643621e-1958-4cd0-a1f2-a592f4770b4e /var            ext4    errors=remount-ro 0       1
EOF"
for x in /dev /sys /proc; do sudo umount /mnt/$x; done


sudo umount ${DEV}1 ${DEV}2 ${DEV}4 ${DEV}3
sync
echo "Finished"
