#!/bin/bash

set -ex

SRC_FOLDER=~/t2-home
DST_FOLDER=/mnt/home/nclab

cp $SRC_FOLDER/bridge/bridge.sh $DST_FOLDER/bridge/bridge.sh
cp $SRC_FOLDER/hostapd/hostapd.conf $DST_FOLDER/hostapd/hostapd.conf
cp $SRC_FOLDER/hostapd/check_hostapd.sh $DST_FOLDER/hostapd/check_hostapd.sh
cp $SRC_FOLDER/wpa/neighbor.conf $DST_FOLDER/wpa/neighbor.conf
cp $SRC_FOLDER/wpa/hopover.conf $DST_FOLDER/wpa/hopover.conf
cp $SRC_FOLDER/wpa/default.conf $DST_FOLDER/wpa/default.conf
cp $SRC_FOLDER/wpa/check_wpa.sh $DST_FOLDER/wpa/check_wpa.sh
cp $SRC_FOLDER/bats-proto-nhop/load_iptables.sh $DST_FOLDER/bats-proto-nhop/load_iptables.sh
cp $SRC_FOLDER/fsm/start_fsm.sh $DST_FOLDER/fsm/start_fsm.sh

echo "change hostname and network/interfaces"