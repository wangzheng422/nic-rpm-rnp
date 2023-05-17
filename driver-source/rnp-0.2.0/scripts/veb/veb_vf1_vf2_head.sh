#!/bin/bash
cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env

ring=2
echo -e " queue$ring tx_tail:  $(dma_r32_n  $(($ring*0x100 + 0x8070)) ), tx head\t: $(dma_r32_n  $(($ring*0x100 + 0x806c)) ) \t "
ring=4
echo -e " queue$ring rx_head:  $(dma_r32_n  $(($ring*0x100 + 0x803c)) )  "

echo ""

ring=3
echo -e " queue$ring tx_tail:  $(dma_r32_n  $(($ring*0x100 + 0x8070)) ), tx head\t: $(dma_r32_n  $(($ring*0x100 + 0x806c)) ) \t "
ring=5
echo -e " queue$ring rx head:  $(dma_r32_n  $(($ring*0x100 + 0x803c)) )  "
