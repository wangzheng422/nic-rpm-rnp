#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env


vm_dmac()
{
    #for:98:03:9b:48:cd:80,  ral:0x9b48cd80 rah:0x80009803
    idx=$1
    echo -e "vm_dmac[$idx] ral  :   $( eth_r32 $(( 0xa000 + 4*$idx  )) )"
    echo -e "vm_dmac[$idx] rah  :   $( eth_r32 $(( 0xa400 + 4*$idx  )) )"
    echo -e "vm_dmac[$idx] mpsar:   $( eth_r32 $(( 0xb400 + 4*$idx  )) )"
}
echo -e "\n\n === dmac table ===\n"
for idx in $(seq 0 127);
do
    vm_dmac $idx
done

echo -e "default rx-ring\t: $( eth_r32  0x806c )"
echo -e "bypass\t\t: $(         eth_r32 0x8000 ) , expect: 0"
echo -e "l2_filter_en\t: $(     eth_r32 0x801c ) , expect: 0x1"
echo -e "redir_en\t: $(         eth_r32 0x8030 ) , expect: 0x1"
echo -e "MRQC\t\t: $(           eth_r32 0x92a0 ) , expect: $(( 1<< 3))"
echo -e "dmac_fctrl\t: $(       eth_r32 0x9110 ) , expect: 0x400"
echo -e "dmac_mcstctrl\t: $(    eth_r32 0x9114 ) , expect: 0"
