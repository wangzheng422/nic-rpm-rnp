#!/bin/bash

ethtool -K rnp00 tx-udp_tnl-segmentation on

ip link add vxlan0 type vxlan \
        id 42 \
        dstport 4789 \
        remote 1.2.3.8 \
        local 1.2.3.3 \
        dev rnp00

ifconfig vxlan0 2.3.4.3 netmask 255.255.255.0 up

ip -d link show vxlan0
