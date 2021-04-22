#!/bin/bash

if [ $# -le 0 ]; then
        echo "Usage:    ./1c_ospf.sh image_folder";
        exit 0
fi

set -ex

ROOT_FOLDER=$1


for x in /dev /sys /proc; do sudo mount -o bind $x ${ROOT_FOLDER}/$x; done


sudo chroot ${ROOT_FOLDER} bash -c "
mkdir -p /var/log/quagga || exit 0
touch /var/log/quagga/zebra.log /var/log/quagga/ospfd.log
chmod 666 /var/log/quagga/*

cd /etc/quagga
touch vtysh.conf zebra.conf ospfd.conf


bash -c 'cat << EOF > zebra.conf
log file /var/log/quagga/zebra.log
EOF'


bash -c 'cat << EOF > ospfd.conf
interface br0
ip ospf dead-interval minimal hello-multiplier 5
ip ospf network point-to-multipoint
ip ospf cost 10

router ospf
network 192.168.100.0/24 area 0
redistribute connected
passive-interface enp5s0
!ospf router-id 1.1.1.1
default-information originate metric 11 metric-type 1

log file /var/log/quagga/ospfd.log
EOF'
"


for x in /dev /sys /proc; do sudo umount ${ROOT_FOLDER}/$x; done
