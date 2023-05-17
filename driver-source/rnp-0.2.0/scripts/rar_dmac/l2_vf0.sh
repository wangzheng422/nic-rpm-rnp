#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

echo -e "bypass\t\t: $(         eth_r32 0x8000         )"

echo -e "l2_filter_en\t: $(     eth_w32 0x801c 0x1     )"
echo -e "redir_en\t: $(         eth_w32 0x8030 0x1     )"
echo -e "MRQC\t\t: $(           eth_w32 0x92a0 $(( 1<<3 )) )"
echo -e "dmac_fctrl\t: $(       eth_w32 0x9110 0x400   )"
echo -e "dmac_mcstctrl\t: $(    eth_w32 0x9114 0x0     )"
#echo -e "dmac_mcstctrl\t: $(    eth_w32 0x9118 0x0     )"
echo ""

#VFNUM=$(( 1*2 ))
#echo -e "vm_dmac_ral\t: $( eth_w32 $(( 0xa000 + 4*$VFNUM )) 0x98039b48 )"
#echo -e "vm_dmac_rah\t: $( eth_w32 $(( 0xa400 + 4*$VFNUM )) 0x8000cd81 )"

#echo -e "vm_dmac_ral\t: $( w32 $(( 0xa000 + 4*$VFNUM )) 0x489b0398 )"
#echo -e "vm_dmac_rah\t: $( w32 $(( 0xa400 + 4*$VFNUM )) 0x800081cd )"

#echo -e "default rx-ring\t: $( eth_w32 $(( 0x806c  )) 2 )"
#echo -e "default rx-ring\t: $( eth_r32 $(( 0x806c  )) 1 )"

### vf0 ===
echo -e "vm_dmac_ral\t: $( eth_w32 $(( 0xa008   )) 0x31304470 )"
echo -e "vm_dmac_rah\t: $( eth_w32 $(( 0xa408   )) 0x8000004e )"
echo -e "vm_dmacmpsar\t: $( eth_w32 $(( 0xb408  )) 0 )"
### vf1 ===
#echo -e "vm_dmac_ral\t: $( eth_w32 $(( 0xa008   )) 0x9b48cd81 )"
#echo -e "vm_dmac_rah\t: $( eth_w32 $(( 0xa408   )) 0x80009803 )"
#echo -e "vm_dmacmpsar\t: $( eth_w32 $(( 0xb408  )) 1 )"

### pf0 ===
#echo -e "vm_dmac_ral\t: $( eth_w32 $(( 0xa008   )) 0x9b48cd00 )"
#echo -e "vm_dmac_rah\t: $( eth_w32 $(( 0xa408   )) 0x80009803 )"
#echo -e "vm_dmacmpsar\t: $( eth_w32 $(( 0xb408  )) 2 )"

#echo -e "vm_dmacmpsar\t: $( eth_w32 $(( 0x92a0  )) 0x8 )"

#echo "=== reg dump ==="
#eth_r32 0xa000 8
#eth_r32 0xa400 8
