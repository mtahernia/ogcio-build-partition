#!/bin/bash

if [ $# -le 0 ]; then
        echo "Usage:    ./1a_make_files.sh image_folder";
        exit 0
fi

set -ex

ROOT_FOLDER=$1
APT_MIRROR=https://deb.debian.org/debian
RELEASE=buster


## Step 1: Download Linux

mkdir -p ${ROOT_FOLDER}
sudo debootstrap --include=sudo,locales-all ${RELEASE} ${ROOT_FOLDER} ${APT_MIRROR}


## Step 2: Configure Linux

for x in /dev /sys /proc; do sudo mount -o bind $x ${ROOT_FOLDER}/$x; done


sudo chroot ${ROOT_FOLDER} bash -c "cat << EOF > /etc/apt/sources.list
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS                    
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ stable main contrib non-free
deb-src http://deb.debian.org/debian/ stable main contrib non-free

#deb http://deb.debian.org/debian/ stable-updates main contrib non-free
#deb-src http://deb.debian.org/debian/ stable-updates main contrib non-free

deb http://deb.debian.org/debian-security stable/updates main
deb-src http://deb.debian.org/debian-security stable/updates main
EOF"
sudo chroot ${ROOT_FOLDER} bash -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"
#sudo chroot ${ROOT_FOLDER} bash -c "chmod 1777 /tmp"
sudo chroot ${ROOT_FOLDER} bash -c "chmod u+s /bin/ping"
# sudo chroot ${ROOT_FOLDER} bash -c "cat << EOF > /etc/locale.gen
# en_US.UTF-8 UTF-8
# en_HK.UTF-8 UTF-8
# EOF"
sudo chroot ${ROOT_FOLDER} bash -c "echo Alpha > /etc/hostname"
sudo chroot ${ROOT_FOLDER} bash -c "echo '127.0.0.1       Alpha' >> /etc/hosts"


sudo chroot ${ROOT_FOLDER} bash -c "apt update"
# sudo chroot ${ROOT_FOLDER} bash -c "apt install -y locales && locale-gen"
sudo chroot ${ROOT_FOLDER} bash -c "apt install -y linux-image-amd64 grub-efi-amd64"


#sudo chroot ${ROOT_FOLDER} bash -c "apt install -y sudo"
#sudo chroot ${ROOT_FOLDER} bash -c "chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo"
sudo chroot ${ROOT_FOLDER} bash -c "useradd -m -s /bin/bash nclab && usermod -aG sudo,netdev nclab"		    # add user nclab and add it to group sudo
#sudo chroot ${ROOT_FOLDER} bash -c "sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd"		    # use bash as default shell
#sudo chroot ${ROOT_FOLDER} bash -c "mkdir /home/nclab && chown nclab.nclab /home/nclab"		# create home directory for nclab
#sudo chroot ${ROOT_FOLDER} bash -c "cp -p /etc/skel/.profile /home/nclab/.bash_profile"
sudo chroot ${ROOT_FOLDER} bash -c "cat << EOF >> /home/nclab/.bashrc
# colorized ls
#export LS_OPTIONS='--color=auto'
#eval \\\`dircolors\\\`
#alias ls='ls \$LS_OPTIONS'
#alias ll='ls \$LS_OPTIONS -l'
#alias l='ls \$LS_OPTIONS -lA'

# colorized PS1
#PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# history format
HISTTIMEFORMAT='%Y-%m-%d %T  '
EOF"

sudo chroot ${ROOT_FOLDER} bash -c "cat << EOF >> /etc/network/interfaces

allow-hotplug enp5s0
iface enp5s0 inet static
    address 10.32.0.23/25
EOF"

sudo chroot ${ROOT_FOLDER} bash -c "sed -i 's/quiet/quiet intel_iommu=on/g' /etc/default/grub"

# Install qemu packages
sudo chroot ${ROOT_FOLDER} bash -c "apt install -y qemu-system-x86 qemu-kvm"

#106
# Install fundamental packages
sudo chroot ${ROOT_FOLDER} bash -c "apt install -y git man bash-completion pciutils usbutils ssh net-tools bridge-utils sshpass zip psmisc wget ntpdate"

#117
# Install required pakages
sudo chroot ${ROOT_FOLDER} bash -c "apt install -y wireless-tools iw wpasupplicant hostapd lm-sensors python-pip libnetfilter-queue-dev quagga npm haveged"
sudo chroot ${ROOT_FOLDER} bash -c "systemctl disable hostapd"

#164
# Install debug pakages
sudo chroot ${ROOT_FOLDER} bash -c "apt install -y netcat telnet iperf3 speedometer tcpdump tree traceroute pv nmap"

# Install dev packages packets
#sudo chroot ${ROOT_FOLDER} bash -c "apt install -y stress parted cmake gcc g++ vim screen gdb valgrind"

#165
# Install pip packages
sudo chroot ${ROOT_FOLDER} bash -c "pip install schedule datetime"

# Clean up
sudo chroot ${ROOT_FOLDER} bash -c "apt autoremove && apt autoremove -y"

# set password for nclab
sudo chroot ${ROOT_FOLDER} bash -c "passwd nclab"

sudo chroot ${ROOT_FOLDER} bash -c "echo 1.0.0 > /home/nclab/version"


for x in /dev /sys /proc; do sudo umount ${ROOT_FOLDER}/$x; done


echo "Finished"
exit
