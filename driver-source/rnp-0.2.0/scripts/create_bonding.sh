#!/bin/bash
systemctl stop NetworkManager.service
ip link add bond1 type bond 
ip link set bond1 type bond mode 1
ip link set bond1 type bond miimon 100
#balance-rr balance-xor broadcast 802.3ad balance-tlb balance-alb

ifconfig rnp00 down
ifconfig rnp10 down

ip link set rnp00 master bond1
ip link set rnp10 master bond1
#
ifconfig bond1 192.168.50.104/24 up

# vlan->bridge
# ip link add link bond1 name bond1.2 type vlan id 2
# ip link set bond1.2 up
# ip link add br0 type bridge
# ip link set bond1.2 master br0
# ip link set br0 up
