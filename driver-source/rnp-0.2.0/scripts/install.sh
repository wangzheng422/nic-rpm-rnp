#!/bin/bash

rmmod rnp 2>/dev/null

dmesg -C

DEV=rnp00
if [ ! -z $1 ];then
    DEV=$1
fi

modprobe mdio

insmod rnp.ko
which nmcli
if [ "$?" -eq "0" ];then
    nmcli dev set $DEV managed no
fi
#ethtool -L rnp00 combined 1
#sysctl -w net.ipv6.conf.$DEV.disable_ipv6=1

#ifconfig $DEV 1.2.3.6 netmask 255.255.255.0 up
sleep 1
dmesg
