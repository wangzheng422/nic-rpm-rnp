#!/bin/bash

cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env


echo " DestMacAddr to ring"
echo "vm_dmac_ral:dmac_lo32 "
eth_r32  0xa000  128
echo "vm_dmac_rah: [31]:enable [15:0]:dmac_hi16 "
eth_r32  0xa400  128
echo -e "vm_dmacmpsar\t: $( eth_r32 $(( 0xb408  ))  )"
