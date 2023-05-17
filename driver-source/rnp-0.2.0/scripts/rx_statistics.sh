#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

level=0
RED="\e[31m"
YELO="\e[33m"
BLUE="\e[34m"
RESET="\e[39m"

rx_port()
{
    nr_port=$1

    echo -e "port$nr_port:"
    echo -e "    rxtrans_pkt_num\t: $(eth_r32_n     $((0x8900 + $nr_port*0x40 )) ) "
    echo -e "    rxtrans_drop_num\t: $(eth_r32_n    $((0x8904 + $nr_port*0x40 )) ) "
}

echo "==== rx statistics ==="
rx_port 0
rx_port 1
rx_port 2
rx_port 3

echo -e "emac_4to1_gather: =="
echo -e "    port0_rx_pkt_num\t: $(eth_r32_n  0x8220 ) "
echo -e "    port1_rx_pkt_num\t: $(eth_r32_n  0x8224 ) "
echo -e "    port2_rx_pkt_num\t: $(eth_r32_n  0x8228 ) "
echo -e "    port3_rx_pkt_num\t: $(eth_r32_n  0x822c ) "
echo -e "   $RED total_rx_pkt_num\t: $(eth_r32_n  0x8240 ) $RESET"

echo -e "emac_pip_parse:                    "
echo -e "    pkt_ingress_num\t: $(eth_r32_n  0x8220 ) "
echo -e "    pkt_egress_num\t: $( eth_r32_n  0x8224 ) "

echo -e "emac_pip_decap:                    "
echo -e "    decap_pkt_in_num\t: $(eth_r32_n  0x82d0 ) "
echo -e "    decap_pkt_out_num\t: $(eth_r32_n  0x82d4 ) "
echo -e "        $RED decap_dma_out \t: $(eth_r32_n  0x82d8 )  $RESET"
echo -e "        decap_bmc_out\t: $(eth_r32_n  0x82dc ) "
echo -e "        ap_switch_out\t: $(eth_r32_n  0x82e0 ) "
echo -e "   vlan_rm_pkts\t\t: $(eth_r32_n  0x82fc ) "
echo -e "   ============= droped pkts ==============="
echo -e "  $YELO invalid_droped_pkts\t: $(eth_r32_n  0x82e8 ) "
echo -e "   filter_droped_pkts\t: $(eth_r32_n  0x82ec ) "
echo -e "     host_l2_match_drop\t: $(eth_r32_n  0x8410 ) "
echo -e "     redir_input_match_drop\t: $(eth_r32_n  0x8414 ) "
echo -e "     redir_etype_match_drop\t: $(eth_r32_n  0x8418 ) "
echo -e "     redir_tcp_syn_match_drop\t: $(eth_r32_n  0x841c ) "
echo -e "     redir_tuple5_match_drop\t: $(eth_r32_n  0x8420 ) "
echo -e "     redir_tcam_match_drop\t: $(eth_r32_n  0x8424 ) "
echo -e "   bmc_droped_pkts\t: $(eth_r32_n  0x82f4 ) "
echo -e "   switch_droped_pkts\t: $(eth_r32_n  0x82f8 ) $RESET"

echo -e "pip_flowctrl: "
echo -e "   rx_fc_pkt_in\t\t: $(eth_r32_n  0x8300 ) "
echo -e "   rx_fc_pkt_out\t: $(eth_r32_n  0x8304 ) "
echo -e "   ring_flow_drop\t: $(eth_r32_n  0x8308 ) "
echo -e "   tc_flow_drop\t\t: $(eth_r32_n  0x830c ) "

echo -e "DMAC:"
echo -e "  $RED dma_pkgs_from_mac0\t: $(dma_r32_n  0x264 ) $RESET"
echo -e "    dma_ififo_rx\t: $(dma_r32_n  0x274 ) "
echo -e "    dma_ofifo_rx\t: $(dma_r32_n  0x280 ) "
echo -e "    rx_mac_cnt\t\t: $(dma_r32_n  0x258 ) "
echo -e "    rx_output\t\t: $(dma_r32_n  0x260 ) "
echo -e "    tx_trans_vms_cnt\t: $(dma_r32_n  0x264 ) "
echo -e "    tx_copy_vms_cnt\t: $(dma_r32_n  0x268 ) "
echo -e "             \t\t: $(dma_r32_n  0x26c ) "
echo -e "             \t\t: $(dma_r32_n  0x280 ) "
echo -e "    pci_rd_reqs\t\t: $(dma_r32_n  0x284 ) "
echo -e "  $RED  pci_wr_to_host\t: $(dma_r32_n  0x288 )/2 $RESET "
echo -e "              \t\t: $(dma_r32_n  0x28c )  "
echo -e "  $RED  pkg_rd_cnt\t\t: $(dma_r32_n  0x290 ) $RESET "
echo -e "  $RED  dma_rx_drop\t\t: $(dma_r32_n  0x114 ) $RESET "
#echo -e "    port0 VEB tx cnt\t: $(dma_r32_n 0x244 ) "
#echo -e "    count_veb_top_12\t: $(dma_r32_n 0x2c8 ) "
for ring in $(seq 0  7)
do
    echo -e "    queue$ring rx head\t:  $(dma_r32_n  $(($ring*0x100 + 0x803c)) )  "
done
echo -e "default rx-ring\t: $( eth_r32 $(( 0x806c  )) 1 )"
