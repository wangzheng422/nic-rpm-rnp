#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

level=0
RED="\e[31m"
YELO="\e[33m"
BLUE="\e[34m"
RESET="\e[39m"


echo "==== DMA tx status ==="
string=$(bar4_r32  0x170)
strings=(${string//:/ })
value=${strings[1]}
# bit 15-12
echo -e "   tx stop stats [3:0]: ${value:0-4:1}"

echo "==== nic tx status ==="
echo -e "   tx_status\t\t: $(dma_r32_n  0x10470 ) "
echo -e "   port0_tx_cnt\t\t: $(dma_r32_n  0x10250 ) "
echo -e "   port1_tx_cnt\t\t: $(dma_r32_n  0x10254 ) "
echo -e "   port2_tx_cnt\t\t: $(dma_r32_n  0x10258 ) "
echo -e "   port3_tx_cnt\t\t: $(dma_r32_n  0x1025c ) "

echo "==== mac tx status ==="
echo -e "   port0_tx_cnt_low\t\t: $(dma_r32_n  0x6088c ) "
echo -e "   port0_tx_cnt_high\t\t: $(dma_r32_n  0x60890 ) "
echo -e "   port1_tx_cnt_low\t\t: $(dma_r32_n  0x7088c ) "
echo -e "   port1_tx_cnt_high\t\t: $(dma_r32_n  0x70890 ) "
echo -e "   port2_tx_cnt_low\t\t: $(dma_r32_n  0x8088c ) "
echo -e "   port2_tx_cnt_high\t\t: $(dma_r32_n  0x80890 ) "
echo -e "   port3_tx_cnt_low\t\t: $(dma_r32_n  0x9088c ) "
echo -e "   port3_tx_cnt_high\t\t: $(dma_r32_n  0x90890 ) "

echo "==== mac rx status ==="
echo -e "   port0_rx_cnt_low\t\t: $(dma_r32_n  0x60900 ) "
echo -e "   port0_rx_cnt_high\t\t: $(dma_r32_n  0x60904 ) "
echo -e "   port1_rx_cnt_low\t\t: $(dma_r32_n  0x70900 ) "
echo -e "   port1_rx_cnt_high\t\t: $(dma_r32_n  0x70904 ) "
echo -e "   port2_rx_cnt_low\t\t: $(dma_r32_n  0x80900 ) "
echo -e "   port2_rx_cnt_high\t\t: $(dma_r32_n  0x80904 ) "
echo -e "   port3_rx_cnt_low\t\t: $(dma_r32_n  0x90900 ) "
echo -e "   port3_rx_cnt_high\t\t: $(dma_r32_n  0x90904 ) "

echo "==== rx parse errors ==="
echo -e "   port0_rxtrans_wdt_err\t\t: $(dma_r32_n  0x18908 ) "
echo -e "   port0_rxtrans_code_err\t\t: $(dma_r32_n  0x1890c ) "
echo -e "   port0_rxtrans_crc_err\t\t: $(dma_r32_n  0x18910 ) "
echo -e "   port0_rxtrans_slen_err\t\t: $(dma_r32_n  0x18914 ) "
echo -e "   port0_rxtrans_glen_err\t\t: $(dma_r32_n  0x18918 ) "
echo -e "   port0_rxtrans_iph_err\t\t: $(dma_r32_n  0x1891c ) "
echo -e "   port0_rxtrans_csum_err\t\t: $(dma_r32_n  0x18920 ) "
echo -e "   port0_rxtrans_len_err\t\t: $(dma_r32_n  0x18924 ) "
echo -e "   port0_rxtrans_cut_err\t\t: $(dma_r32_n  0x18928 ) "
echo -e "   port0_rxtrans_except_bytes\t\t: $(dma_r32_n  0x1892c ) "
echo -e "   port0_rxtrans_bytes_g1600\t\t: $(dma_r32_n  0x18930 ) "

echo -e "   port1_rxtrans_wdt_err\t\t: $(dma_r32_n  0x18948 ) "
echo -e "   port1_rxtrans_code_err\t\t: $(dma_r32_n  0x1894c ) "
echo -e "   port1_rxtrans_crc_err\t\t: $(dma_r32_n  0x18950 ) "
echo -e "   port1_rxtrans_slen_err\t\t: $(dma_r32_n  0x18954 ) "
echo -e "   port1_rxtrans_glen_err\t\t: $(dma_r32_n  0x18958 ) "
echo -e "   port1_rxtrans_iph_err\t\t: $(dma_r32_n  0x1895c ) "
echo -e "   port1_rxtrans_csum_err\t\t: $(dma_r32_n  0x18960 ) "
echo -e "   port1_rxtrans_len_err\t\t: $(dma_r32_n  0x18964 ) "
echo -e "   port1_rxtrans_cut_err\t\t: $(dma_r32_n  0x18968 ) "
echo -e "   port1_rxtrans_except_bytes\t\t: $(dma_r32_n  0x1896c ) "
echo -e "   port1_rxtrans_bytes_g1600\t\t: $(dma_r32_n  0x18970 ) "

echo -e "   port2_rxtrans_wdt_err\t\t: $(dma_r32_n  0x18988 ) "
echo -e "   port2_rxtrans_code_err\t\t: $(dma_r32_n  0x1898c ) "
echo -e "   port2_rxtrans_crc_err\t\t: $(dma_r32_n  0x18990 ) "
echo -e "   port2_rxtrans_slen_err\t\t: $(dma_r32_n  0x18994 ) "
echo -e "   port2_rxtrans_glen_err\t\t: $(dma_r32_n  0x18998 ) "
echo -e "   port2_rxtrans_iph_err\t\t: $(dma_r32_n  0x1899c ) "
echo -e "   port2_rxtrans_csum_err\t\t: $(dma_r32_n  0x189a0 ) "
echo -e "   port2_rxtrans_len_err\t\t: $(dma_r32_n  0x189a4 ) "
echo -e "   port2_rxtrans_cut_err\t\t: $(dma_r32_n  0x189a8 ) "
echo -e "   port2_rxtrans_except_bytes\t\t: $(dma_r32_n  0x189ac ) "
echo -e "   port2_rxtrans_bytes_g1600\t\t: $(dma_r32_n  0x189b0 ) "


echo -e "   port2_rxtrans_wdt_err\t\t: $(dma_r32_n  0x189c8 ) "
echo -e "   port2_rxtrans_code_err\t\t: $(dma_r32_n  0x189cc ) "
echo -e "   port2_rxtrans_crc_err\t\t: $(dma_r32_n  0x189c0 ) "
echo -e "   port2_rxtrans_slen_err\t\t: $(dma_r32_n  0x189d4 ) "
echo -e "   port2_rxtrans_glen_err\t\t: $(dma_r32_n  0x189d8 ) "
echo -e "   port2_rxtrans_iph_err\t\t: $(dma_r32_n  0x189dc ) "
echo -e "   port2_rxtrans_csum_err\t\t: $(dma_r32_n  0x189e0 ) "
echo -e "   port2_rxtrans_len_err\t\t: $(dma_r32_n  0x189e4 ) "
echo -e "   port2_rxtrans_cut_err\t\t: $(dma_r32_n  0x189e8 ) "
echo -e "   port2_rxtrans_except_bytes\t\t: $(dma_r32_n  0x189ec ) "
echo -e "   port2_rxtrans_bytes_g1600\t\t: $(dma_r32_n  0x189f0 ) "

echo "==== nic trans status ==="
echo -e "   port0_rx_in_cnt\t\t: $(dma_r32_n  0x18900 ) "
echo -e "   port0_rx_drop_cnt\t\t: $(dma_r32_n  0x18904 ) "
echo -e "   port1_rx_in_cnt\t\t: $(dma_r32_n  0x18940 ) "
echo -e "   port1_rx_drop_cnt\t\t: $(dma_r32_n  0x18944 ) "
echo -e "   port2_rx_in_cnt\t\t: $(dma_r32_n  0x18980 ) "
echo -e "   port2_rx_drop_cnt\t\t: $(dma_r32_n  0x18984 ) "
echo -e "   port3_rx_in_cnt\t\t: $(dma_r32_n  0x189c0 ) "
echo -e "   port3_rx_drop_cnt\t\t: $(dma_r32_n  0x189c4 ) "

echo "==== nic 4to1 status ==="
echo -e "   port0_rx_to_next_cnt\t\t: $(dma_r32_n  0x18220 ) "
echo -e "   port1_rx_to_next_cnt\t\t: $(dma_r32_n  0x18224 ) "
echo -e "   port2_rx_to_next_cnt\t\t: $(dma_r32_n  0x18228 ) "
echo -e "   port3_rx_to_next_cnt\t\t: $(dma_r32_n  0x1822c ) "

echo -e "   port0_rx_to_drop_cnt\t\t: $(dma_r32_n  0x18230 ) "
echo -e "   port1_rx_to_drop_cnt\t\t: $(dma_r32_n  0x18234 ) "
echo -e "   port2_rx_to_drop_cnt\t\t: $(dma_r32_n  0x18238 ) "
echo -e "   port3_rx_to_drop_cnt\t\t: $(dma_r32_n  0x1823c ) "

echo "==== nic parse status ==="
echo -e "   port3_rx_in_cnt\t\t: $(dma_r32_n  0x18290 ) "
echo -e "   port3_rx_out_cnt\t\t: $(dma_r32_n  0x18294 ) "

echo "==== dma status ==="
string=$(bar4_r32  0x110)
strings=(${string//:/ })
value=${strings[1]}
# bit 30:24
#echo -e "   rx stop ring id\t\t: ${value:0-8:2}"
echo -e "   rx ring drop count\t\t: $(dma_r32_n  0x114 ) "

echo "==== DMA head tail ==="

for ring in $(seq 0  127)
do
    echo -e "queue$ring tx head\t: $(dma_r32_n  $(($ring*0x100 + 0x806c)) ) \t, tx_tail:  $(dma_r32_n  $(($ring*0x100 + 0x8070)) )  "
done

for ring in $(seq 0  127)
do
    echo -e "queue$ring rx head\t: $(dma_r32_n  $(($ring*0x100 + 0x803c)) ) \t, rx_tail:  $(dma_r32_n  $(($ring*0x100 + 0x8040)) )  "
done
