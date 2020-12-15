#!/bin/bash

set -ex

SRC_FOLDER=image
DST_FOLDER=~/conf-test

mkdir -p $DST_FOLDER

sudo cp -p $SRC_FOLDER/home/nclab/bridge/bridge.sh $DST_FOLDER/
sudo cp -p $SRC_FOLDER/home/nclab/hostapd/check_hostapd.sh $DST_FOLDER/
sudo cp -p $SRC_FOLDER/home/nclab/wpa/check_wpa.sh $DST_FOLDER/
sudo cp -p $SRC_FOLDER/home/nclab/wpa/default.conf $DST_FOLDER/
sudo cp -p $SRC_FOLDER/home/nclab/wpa/hopover.conf $DST_FOLDER/
sudo cp -p $SRC_FOLDER/home/nclab/hostapd/hostapd.conf $DST_FOLDER/
sudo cp -p $SRC_FOLDER/etc/hostname $DST_FOLDER/
sudo cp -p $SRC_FOLDER/etc/hosts $DST_FOLDER/
sudo cp -p $SRC_FOLDER/etc/network/interfaces $DST_FOLDER/
sudo cp -p $SRC_FOLDER/home/nclab/wpa/neighbor.conf $DST_FOLDER/
sudo cp -p $SRC_FOLDER/home/nclab/fsm/start_fsm.sh $DST_FOLDER/
