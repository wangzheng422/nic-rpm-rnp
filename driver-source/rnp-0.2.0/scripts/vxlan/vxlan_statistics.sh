#!/bin/bash

cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env

echo -e " vxlan table"
eth_r32_n 0xB800 64

echo -e "   vxlan offloading: $(eth_r32_n  0x8004 )  "
echo -e "   vxlan port\t: $(eth_r32_n  0x8010 )  "
echo -e "   vxlan en\t: $(eth_r32_n  0x0000 )  "
echo -e "   inner_dmac\t: $(eth_r32  0x0008 ) $(eth_r32  0x000c ) "
echo -e "   outer_dmac\t: $(eth_r32  0x0010 ) $(eth_r32  0x0014 ) "
echo -e "   outer_dip\t: $(eth_r32  0x0018 ) "
echo -e "   outer_sip\t: $(eth_r32  0x001c ) "
echo -e "   outer_outer_sport_outer_dport: $(eth_r32  0x0020 ) "
echo -e "   vxlan seg0\t: $(eth_r32_n  0x0024 )  "
echo -e "   vxlan seg1\t: $(eth_r32_n  0x0028 )  "



echo -e "   rx vxlan pkt num\t: $(eth_r32_n  0x8274 )  "
