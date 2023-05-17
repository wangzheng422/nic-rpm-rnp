#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

level=0
RED="\e[31m"
YELO="\e[33m"
BLUE="\e[34m"
RESET="\e[39m"

echo "==== tx statistics ==="

for ring in $(seq 0  8)
do
    echo -e "    queue$ring tx head\t: $(dma_r32_n  $(($ring*0x100 + 0x806c)) ) \t, tx_tail:  $(dma_r32_n  $(($ring*0x100 + 0x8070)) )  "
done



echo -e "DMAC:"
echo -e "  $RED port0_tx_cnt\t\t: $(dma_r32_n  0x244 ) $RESET"
echo -e "   port1_tx_cnt\t\t: $(dma_r32_n  0x248 ) "
echo -e "   port2_tx_cnt\t\t: $(dma_r32_n  0x24c ) "
echo -e "   port3_tx_cnt\t\t: $(dma_r32_n  0x250 ) "


echo -e "emac_1to4_mod: "
echo -e "   $RED in0_tx_pkt_num\t: $(eth_r32_n  0x0200 ) $RESET "
echo -e "    in1_tx_pkt_num\t: $(eth_r32_n  0x0204 ) "
echo -e "    in2_tx_pkt_num\t: $(eth_r32_n  0x0208 ) "
echo -e "    in3_tx_pkt_num\t: $(eth_r32_n  0x020c ) "

echo -e "emac_tx_trans: "
echo -e "   $RED port0 emac_tx_trans\t: $(eth_r32_n  0x0250 ) $RESET "
echo -e "    port1 emac_tx_trans\t: $(eth_r32_n  0x0254 ) "
echo -e "    port2 emac_tx_trans\t: $(eth_r32_n  0x0258 ) "
echo -e "    port3 emac_tx_trans\t: $(eth_r32_n  0x025c )  "

