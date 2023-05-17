#!/bin/bash
ip link add link rnp10 name rnp10.3112 type vlan id 3112
ip address add 192.168.30.105/24 dev rnp10.3112
ip link set rnp10.3112 up
ip link add link rnp10.3112 name rnp10.3112.3110 type vlan id 3110
ip address add 192.168.50.105/24 dev rnp10.3112.3110
ip link set rnp10.3112.3110 up
ip link set rnp10.3112.3110 up

