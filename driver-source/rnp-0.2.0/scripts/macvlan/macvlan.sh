#!/bin/bash

ip link add macvlan1 link rnp00 type macvlan mode bridge

#ip netns add net1
#ip link set macvlan1 netns net1

ip addr add 3.4.5.3/24 dev macvlan1
ip link set macvlan1 up
