#!/bin/bash

set -ex

ROOT_FOLDER=image


for x in /dev /sys /proc; do sudo mount -o bind $x ${ROOT_FOLDER}/$x; done


# Install required pakages
sudo chroot ${ROOT_FOLDER} bash -c "apt install -y net-tools bridge-utils \
hostapd wpasupplicant lm-sensors python-pip libnetfilter-queue-dev sshpass quagga nodejs zip npm psmisc"

# Install debug pakages
sudo chroot ${ROOT_FOLDER} bash -c "apt install -y netcat telnet iperf3 speedometer \
tcpdump tree htop traceroute"

# Install dev packages packets
#sudo chroot ${ROOT_FOLDER} bash -c "apt install -y stress parted cmake gcc g++ vim screen gdb valgrind"

# Install pip packages
sudo chroot ${ROOT_FOLDER} bash -c "pip install schedule datetime"


sudo cp *.deb ${ROOT_FOLDER}/
sudo chroot ${ROOT_FOLDER} bash -c "dpkg -i box.deb"
sudo chroot ${ROOT_FOLDER} bash -c "dpkg -i bats-code-nhop-0.1-Linux-x86_64.deb"
sudo chroot ${ROOT_FOLDER} bash -c "dpkg -i fsm-0.1-Linux-x86_64.deb"
# Edit setup.sh if needed
sudo chroot ${ROOT_FOLDER} bash -c "/home/nclab/setup.sh"


sudo chroot ${ROOT_FOLDER} bash -c "cat << EOF >> /etc/network/interfaces

allow-hotplug enp5s0
iface enp5s0 inet static
    address 10.32.0.23/25
EOF"


for x in /dev /sys /proc; do sudo umount ${ROOT_FOLDER}/$x; done