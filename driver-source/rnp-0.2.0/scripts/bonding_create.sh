#!/bin/bash


ip link add bond1 type bond mode active-backup miimon 100
#ip link add bond1 type bond  mode broadcast 
#balance-rr balance-xor broadcast 802.3ad balance-tlb balance-alb

ip link set rnp00 down
ip link set rnp00 master bond1

ip link set rnp10 down
ip link set rnp10 master bond1

ip addr add 192.168.50.104/24  dev bond1 
ip link set bond1 up

# vlan->bridge
# ip link del br0 
# ip link add link bond1 name bond1.2 type vlan id 2
# ip link set bond1.2 up
# ip link add br0 type bridge
# ip link set bond1.2 master br0
# ip link set br0 up
