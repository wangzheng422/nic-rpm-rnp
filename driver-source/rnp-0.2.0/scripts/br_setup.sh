#!/bin/bash

if [ "$1" == "del" ];then
    ip link set dev br0 down
    ip link delete dev br0
    exit 0
fi

DEV0=${1:-eth1}
DEV1=${2:-eth2}

ip link add name br0 type bridge
ip link set dev br0 up

ip link set dev $DEV0 promisc on
ip addr flush dev $DEV0
ip link set dev $DEV0 up
ip link set dev $DEV0 master  br0

ip link set dev $DEV1 promisc on
ip addr flush dev $DEV1
ip link set dev $DEV1 up
ip link set dev $DEV1 master  br0

echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv4/conf/all/proxy_arp
