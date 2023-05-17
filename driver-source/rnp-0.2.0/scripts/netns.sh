#!/bin/bash

DEV=${1:-enp1s0f1}
IP=${2:-1.2.3.10}
NS=net1

ip netns del $NS || true
ip netns add $NS
ip link  set dev enp1s0f1 netns net1
ip netns exec $NS ifconfig $DEV $IP netmask 255.255.255.0 up

ip netns exec $NS ifconfig -a

echo "networknamespace $NS"

ip netns list
