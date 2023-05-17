#!/bin/bash

cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env

idx=$1
IFS=':' read -r -a macaddr <<< "$2"
ring=$3

echo "rar[$idx] mac:${macaddr[@]}, => ring:$ring"

dmac_entry_dump()
{
    idx=$1
    echo -e "$idx \tdmac_rah: $(eth_r32 $(( 0xa400 + $idx*4 )) ), $(eth_r32 $(( 0xa000 + $idx*4 ))), ring=$(eth_r32 $(( 0xb400 + $idx*4 ))) "
}

echo -e "default rx-ring\t: $( eth_w32 $(( 0x806c  )) 1 )"

echo -e "vm_dmac_ral\t: $( eth_w32 $(( 0xa000 + 4*$idx ))  $((  ( 0x${macaddr[2]} <<24) | ( 0x${macaddr[3]} <<16) | ( 0x${macaddr[4]} <<8) | ( 0x${macaddr[5]} <<0)  ))  )"
echo -e "vm_dmac_rah\t: $( eth_w32 $(( 0xa400 + 4*$idx ))  $(( (1<<31) | ( 0x${macaddr[0]} << 8) | ( 0x${macaddr[1]}) )) )"
echo -e "vm_dmacmpsar_ring/2\t: $( eth_w32 $(( 0xb400 + 4*$idx  )) $(( $ring >> 1 )) )"

dmac_entry_dump $idx

