#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

echo -e "port0 VEB tx cnt:   $( bar4_r32 0x244 ) "
echo -e "count_veb_top_12:   $( bar4_r32 0x2c8 ) "


echo "=== vf1: tx==="
echo -e "ring2_tx_head   :   $( bar4_r32 $(( 0x806c + 0x100*2  )) ) "
echo -e "ring2_tx_tail   :   $( bar4_r32 $(( 0x8070 + 0x100*2  )) ) "

#echo -e "ring3_tx_head   :   $( bar4_r32 $(( 0x806c + 0x100*3  )) ) "
#echo -e "ring3_tx_tail   :   $( bar4_r32 $(( 0x8070 + 0x100*3  )) ) "

echo "=== vf2: rx==="
echo -e "ring4_rx_head   :   $( bar4_r32 $(( 0x803c + 0x100*4  )) ) "
echo -e "ring4_rx_tail   :   $( bar4_r32 $(( 0x8040 + 0x100*4  )) ) "
echo -e "ring5_rx_head   :   $( bar4_r32 $(( 0x803c + 0x100*5  )) ) "
echo -e "ring5_rx_tail   :   $( bar4_r32 $(( 0x8040 + 0x100*5  )) ) "
echo -e "ring2_rx_head   :   $( bar4_r32 $(( 0x803c + 0x100*2  )) ) "
echo -e "ring2_rx_tail   :   $( bar4_r32 $(( 0x8040 + 0x100*2  )) ) "
