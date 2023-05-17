#!/bin/bash

cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env

level=0
RED="\e[31m"
YELO="\e[33m"
BLUE="\e[34m"
RESET="\e[39m"


echo -e "l2_filter_en\t: $(     eth_r32 0x801c ) "
echo -e "redir_en\t: $(         eth_r32 0x8030 ) "
echo -e "RSS_MRQC\t: $(       eth_r32 0x92a0 ) "
echo -e "dmac_fctrl\t: $(       eth_r32 0x9110 ) "
echo -e "dmac_mcstctrl\t: $(    eth_r32 0x9114 ) "

echo "rss table"
eth_r32  0xe000 8

echo  "vlan strip table"
eth_r32  0x8040 7
echo ""
echo -e "\nvlan filter table"
eth_r32  0xB000 16
echo -e "   vlan filter enable\t: $(eth_r32  0x9118 ) , expect:0x40000000 "

echo -e "\ntc_port_offset_table"
eth_r32 0xe840 4

echo ""
echo -e "   pkt_layer1_vlan_num\t: $(eth_r32_n  0x8280 )  "
echo -e "   pkt_layer2_vlan_num\t: $(eth_r32_n  0x8284 ) "
echo -e "   pkt_802_3_num\t: $(eth_r32_n  0x82c0 )  "
echo -e " $RED  decap_rm_vlan_num\t: $(eth_r32_n  0x82fc ) $RESET "

echo -e "\nvlan pfv1vf table"
eth_r32  0xB600 12
echo -e " -----"
eth_r32  0xB700 12
