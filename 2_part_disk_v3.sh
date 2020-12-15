#!/bin/bash

set -ex

ROOT_FOLDER=image
DEV=/dev/sdb


## Step 3: Partition disk and copy files

cat << EOF | sudo sfdisk ${DEV}
label: gpt
label-id: F6E50314-288F-094C-B2C7-3A661157CA2C
device: /dev/sdb
unit: sectors
first-lba: 2048
last-lba: 31277194

/dev/sdb1 : start=        2048, size=      204800, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B, uuid=9BFF6510-405B-6C46-9236-1B3CA453C0B3
/dev/sdb2 : start=      206848, size=      512000, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=7DC7E3A1-B8F9-C14C-961D-F6F6C9E7CC87
/dev/sdb3 : start=      718848, size=     8388608, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=DF69ABE4-E390-134C-A7A4-1C178D229FDF
/dev/sdb4 : start=     9107456, size=     2097152, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=41C47DEE-18DF-E947-905A-70FFA40A5A1E
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
