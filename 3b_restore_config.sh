#!/bin/bash

set -ex

CONF_FOLDER=~/conf-t0
DST_FOLDER=/mnt

mkdir -p $DST_FOLDER

sudo cp -p $CONF_FOLDER/bridge.sh $DST_FOLDER/home/nclab/bridge/
sudo cp -p $CONF_FOLDER/check_hostapd.sh $DST_FOLDER/home/nclab/hostapd/
sudo cp -p $CONF_FOLDER/check_wpa.sh $DST_FOLDER/home/nclab/wpa/
sudo cp -p $CONF_FOLDER/default.conf $DST_FOLDER/home/nclab/wpa/
sudo cp -p $CONF_FOLDER/hopover.conf $DST_FOLDER/home/nclab/wpa/
sudo cp -p $CONF_FOLDER/hostapd.conf $DST_FOLDER/home/nclab/hostapd/
sudo cp -p $CONF_FOLDER/hostname $DST_FOLDER/etc/
sudo cp -p $CONF_FOLDER/hosts $DST_FOLDER/etc/
sudo cp -p $CONF_FOLDER/interfaces $DST_FOLDER/etc/network/
sudo cp -p $CONF_FOLDER/neighbor.conf $DST_FOLDER/home/nclab/wpa/
sudo cp -p $CONF_FOLDER/start_fsm.sh $DST_FOLDER/home/nclab/fsm/
