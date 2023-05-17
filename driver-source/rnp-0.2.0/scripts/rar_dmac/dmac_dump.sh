#!/bin/bash

cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env

dmac_entry_dump()
{
    idx=$1
    echo -e "$idx \tdmac_rah: $(eth_r32 $(( 0xa400 + $idx*4 )) ), $(eth_r32 $(( 0xa000 + $idx*4 ))), ring=$(eth_r32 $(( 0xb400 + $idx*4 ))) "
}

for i in $(seq 0 127)
do
    dmac_entry_dump $i
done

echo -e "bypass\t\t: $(         eth_r32 0x8000), expect 0"
echo -e "l2_filter_en\t: $(     eth_r32 0x801c ), expect 1 "
echo -e "redir_en\t: $(         eth_r32 0x8030 ), expect 1"
echo -e "RSS_MRQC\t: $(       eth_r32 0x92a0 ) , expect bit3 = 1 "
echo -e "dmac_fctrl\t: $(       eth_r32 0x9110 , expect 0x400) "
echo -e "dmac_mcstctrl\t: $(    eth_r32 0x9114 , expect 0) "
echo -e "default rx-ring\t: $( eth_r32 $(( 0x806c  )) 1 )"
