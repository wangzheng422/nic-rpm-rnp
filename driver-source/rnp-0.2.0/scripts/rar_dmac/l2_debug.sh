#!/bin/bash

cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env


#echo -e "default rx-ring\t: $( eth_w32  0x806c )"
echo -e "bypass\t\t: $(         eth_w32 0x8000 ) "
echo -e "l2_filter_en\t: $(     eth_w32 0x801c 0x1) "
echo -e "redir_en\t: $(         eth_w32 0x8030 0x1) "
echo -e "RSS_MRQC\t\t: $(       eth_w32 0x92a0 $(( 1<< 3))) "
echo -e "dmac_fctrl\t: $(       eth_w32 0x9110 0x400 ) "
echo -e "dmac_mcstctrl\t: $(    eth_w32 0x9114 0 ) "
