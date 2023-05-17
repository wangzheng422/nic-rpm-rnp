#!/bin/bash

if [ "$1" == "del" ];then
    ethtool -K rnp00 rxvlan off
    ethtool -K rnp00 txvlan off
    exit 0
fi

##ethtool -L rnp00 combined 1

ethtool -K rnp00 rxvlan on
ethtool -K rnp00 txvlan on

VLAN_DEV=vlan4

ip link add link rnp00 name $VLAN_DEV type vlan id 4
ifconfig  $VLAN_DEV 192.168.30.100 netmask 255.255.255.0 up

 ip -d link show  $VLAN_DEV
