#!/bin/bash

#pip3 install python-pytuntap scapy

if [[ "$1" == "del" ]];then
    ifconfig br1 down
    brctl delbr br1 2>/dev/null

    ip link del tap0
fi

ip tuntap add mode tap dev tap0


#ip netns add ns1
#ip link set dev rnp00 netns ns1
#ip link set dev tun0  netns ns1


brctl addbr br1
brctl addif br1 rnp00
brctl addif br1 tap0

ifconfig rnp00 up
ifconfig tap0 up
ifconfig br1 up

#ip netns exec ns1 /bin/bash

sysctl -w net.ipv4.ip_forward=1
#ip route add default via 1.2.3.8

#iptables -A FORWARD -i tap0 -j ACCEPT
#iptables -t nat -A POSTROUTING -o rnp00 -i tap0 -j MASQUERADE
