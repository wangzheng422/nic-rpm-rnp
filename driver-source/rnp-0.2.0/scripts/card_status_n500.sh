#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

level=0
RED="\e[31m"
YELO="\e[33m"
BLUE="\e[34m"
RESET="\e[39m"


#echo "==== DMA tx status ==="
#string=$(bar4_r32  0x170)
#strings=(${string//:/ })
#value=${strings[1]}
## bit 15-12
#echo -e "   tx stop stats [3:0]: ${value:0-4:1}"
#
#echo "==== nic tx status ==="
#echo -e "   tx_status\t\t: $(dma_r32_n  0x10470 ) "
#echo -e "   port0_tx_cnt\t\t: $(dma_r32_n  0x10250 ) "
#echo -e "   port1_tx_cnt\t\t: $(dma_r32_n  0x10254 ) "
#echo -e "   port2_tx_cnt\t\t: $(dma_r32_n  0x10258 ) "
#echo -e "   port3_tx_cnt\t\t: $(dma_r32_n  0x1025c ) "
#
#echo "==== mac tx status ==="
#echo -e "   port0_tx_cnt_low\t\t: $(dma_r32_n  0x6088c ) "
#echo -e "   port0_tx_cnt_high\t\t: $(dma_r32_n  0x60890 ) "
#echo -e "   port1_tx_cnt_low\t\t: $(dma_r32_n  0x7088c ) "
#echo -e "   port1_tx_cnt_high\t\t: $(dma_r32_n  0x70890 ) "
#echo -e "   port2_tx_cnt_low\t\t: $(dma_r32_n  0x8088c ) "
#echo -e "   port2_tx_cnt_high\t\t: $(dma_r32_n  0x80890 ) "
#echo -e "   port3_tx_cnt_low\t\t: $(dma_r32_n  0x9088c ) "
#echo -e "   port3_tx_cnt_high\t\t: $(dma_r32_n  0x90890 ) "

#echo "==== mac rx status ==="
#echo -e "   port0_rx_cnt_low\t\t: $(dma_r32_n  0x60900 ) "
#echo -e "   port0_rx_cnt_high\t\t: $(dma_r32_n  0x60904 ) "
#echo -e "   port1_rx_cnt_low\t\t: $(dma_r32_n  0x70900 ) "
#echo -e "   port1_rx_cnt_high\t\t: $(dma_r32_n  0x70904 ) "
#echo -e "   port2_rx_cnt_low\t\t: $(dma_r32_n  0x80900 ) "
#echo -e "   port2_rx_cnt_high\t\t: $(dma_r32_n  0x80904 ) "
#echo -e "   port3_rx_cnt_low\t\t: $(dma_r32_n  0x90900 ) "
#echo -e "   port3_rx_cnt_high\t\t: $(dma_r32_n  0x90904 ) "



echo "==== emac_rx_trans ==="
echo -e "   port_rxtrans_cs             \t\t:	$(dma_r32_n  0x18100)\t\t"
echo -e "   port_rxtrans_ns             \t\t:	$(dma_r32_n  0x18104)\t\t"
echo -e "   port_rxtrans_pkt_num        \t\t:	$(dma_r32_n  0x18900)\t\t"
echo -e "   port_rxtrans_pkt_out_num\t\t:	$(dma_r32_n  0x18904)\t\t"
echo -e "   port_rxtrans_drop_num\t\t:		$(dma_r32_n  0x18908)\t\t"
echo -e "   port_rxtrans_eth_pkt_num\t\t:	$(dma_r32_n  0x1890c)\t\t"
echo -e "   port_rxtrans_802_3_num\t\t:		$(dma_r32_n  0x18910)\t\t"
echo -e "   port_rxtrans_ctrl_pkt_num   \t\t:	$(dma_r32_n  0x18914)\t\t"
echo -e "   port_rxtrans_udp_pkt_num\t\t:	$(dma_r32_n  0x18918)\t\t"
echo -e "   port_rxtrans_tcp_pkt_num\    t\t:	$(dma_r32_n  0x1891c)\t\t"
echo -e "   port_rxtrans_icmp_pkt_num\t\t:	$(dma_r32_n  0x18920)\t\t"
echo -e "   port_rxtrans_lcs_err_num\t\t: 	$(dma_r32_n  0x18924)\t\t"
echo -e "   port_rxtrans_len_err_num\t\t: 	$(dma_r32_n  0x18928)\t\t"
echo -e "   port_rxtrans_da_fail_num\t\t: 	$(dma_r32_n  0x1892c)\t\t"
echo -e "   port_rxtrans_sa_fail_num\t\t: 	$(dma_r32_n  0x18930)\t\t"
echo -e "   port_rxtrans_slen_err_num\t\t: 	$(dma_r32_n  0x18934)\t\t"
echo -e "   port_rxtrans_glen_err_num\t\t: 	$(dma_r32_n  0x18938)\t\t"
echo -e "   port_rxtrans_iph_err_num\t\t: 	$(dma_r32_n  0x1893c)\t\t"
echo -e "   port_rxtrans_payload_err_num\t\t: 	$(dma_r32_n  0x18940)\t\t"
echo -e "   port_rxtrans_ipv4_num\t\t: 		$(dma_r32_n  0x18944)\t\t"
echo -e "   port_rxtrans_ipv6_num\t\t: 		$(dma_r32_n  0x18948)\t\t"
echo -e "   port_rxtrans_cut_err_num\t\t: 	$(dma_r32_n  0x1894c)\t\t"
echo -e "   port_rxtrans_except_bytes\t\t: 	$(dma_r32_n  0x18950)\t\t"
echo -e "   port_rxtrans_fcs_err_num\t\t: 	$(dma_r32_n  0x18954)\t\t"


echo "==== emac_rx_gather ==="
echo -e "   gat_rx_cs\t\t: 	        $(dma_r32_n  0x18120)"
echo -e "   gat_rx_ns\t\t: 	        $(dma_r32_n  0x18124)"
echo -e "   port_rx_pkt_num\t\t: 	        $(dma_r32_n  0x18220)"
echo -e "   port_rx_multi_pkt_num\t\t: 	$(dma_r32_n  0x18224)"
echo -e "   port_rx_broad_pkt_num\t\t: 	$(dma_r32_n  0x18228)"
echo -e "   port_rx_drop_pkt_num\t\t: 	$(dma_r32_n  0x18230)"
echo -e "   total_gat_rx_pkt_num\t\t: 	$(dma_r32_n  0x18240)"
echo -e "   port_rx_mac_cut_num\t\t: 	$(dma_r32_n  0x18304)"
echo -e "   port_rx_mac_lcs_err_num\t\t: 	$(dma_r32_n  0x18308)"
echo -e "   port_rx_mac_len_err_num\t\t: 	$(dma_r32_n  0x1830c)"
echo -e "   port_rx_mac_slen_err_num\t\t: 	$(dma_r32_n  0x18310)"
echo -e "   port_rx_mac_glen_err_num\t\t: 	$(dma_r32_n  0x18314)"
echo -e "   port_rx_mac_fcs_err_num\t\t: 	$(dma_r32_n  0x18318)"
echo -e "   port_rx_mac_sfcs_err_num\t\t: 	$(dma_r32_n  0x1831c)"
echo -e "   port_rx_mac_gfcs_err_num\t\t: 	$(dma_r32_n  0x18320)"


echo "==== emac_pip_parse ==="
echo -e "   emac_pip_cs\t\t: 			$(dma_r32_n  0x18128)"
echo -e "   emac_pip_ns\t\t: 			$(dma_r32_n  0x1812c)"
echo -e "   pkt_arp_req_num\t\t: 		$(dma_r32_n  0x18250)"
echo -e "   pkt_arp_response_num\t\t: 		$(dma_r32_n  0x18254)"
echo -e "   pkt_icmp_num\t\t: 			$(dma_r32_n  0x18258)"
echo -e "   pkt_udp_num\t\t: 			$(dma_r32_n  0x1825c)"
echo -e "   pkt_tcp_num\t\t: 			$(dma_r32_n  0x18260)"
echo -e "   pkt_arp_cut_num\t\t: 		$(dma_r32_n  0x18264)"
echo -e "   pkt_nd_cut_num\t\t: 		$(dma_r32_n  0x18268)"
echo -e "   pkt_sctp_num\t\t: 			$(dma_r32_n  0x1826c)"
echo -e "   pkt_tcpsyn_num\t\t: 		$(dma_r32_n  0x18270)"
echo -e "   pkt_fragment_num\t\t: 		$(dma_r32_n  0x1827c)"
echo -e "   pkt_layer1_vlan_num\t\t: 		$(dma_r32_n  0x18280)"
echo -e "   pkt_layer2_vlan_num\t\t: 		$(dma_r32_n  0x18284)"
echo -e "   pkt_ipv4_num\t\t: 			$(dma_r32_n  0x18288)"
echo -e "   pkt_ipv6_num\t\t: 			$(dma_r32_n  0x1828c)"
echo -e "   pkt_ingress_num\t\t: 		$(dma_r32_n  0x18290)"
echo -e "   pkt_egress_num\t\t: 		$(dma_r32_n  0x18294)"
echo -e "   pkt_ip_hdr_len_err_num\t\t: 	$(dma_r32_n  0x18298)"
echo -e "   pkt_ip_pkt_len_err_num\t\t: 	$(dma_r32_n  0x1829c)"
echo -e "   pkt_l3_hdr_chk_err_num\t\t: 	$(dma_r32_n  0x182a0)"
echo -e "   pkt_l4_hdr_chk_err_num\t\t: 	$(dma_r32_n  0x182a4)"
echo -e "   pkt_sctp_chk_err_num\t\t: 		$(dma_r32_n  0x182a8)"
echo -e "   pkt_vlan_err_num\t\t: 		$(dma_r32_n  0x182ac)"
echo -e "   pkt_rdma_num\t\t: 			$(dma_r32_n  0x182b0)"
echo -e "   pkt_arp_auto_response_num\t\t: 	$(dma_r32_n  0x182b4)"
echo -e "   pkt_icmpv6_num\t\t: 		$(dma_r32_n  0x182b8)"
echo -e "   pkt_ipv6_extend_num\t\t: 		$(dma_r32_n  0x182bc)"
echo -e "   pkt_802_3_num\t\t: 			$(dma_r32_n  0x182c0)"
echo -e "   pkt_except_short_num\t\t: 		$(dma_r32_n  0x182c4)"
echo -e "   pkt_ptp_num\t\t: 			$(dma_r32_n  0x182c8)"
echo -e "   pkt_NS_req_num\t\t: 		$(dma_r32_n  0x18274)"
echo -e "   pkt_NS_NA_auto_response_num\t\t: 	$(dma_r32_n  0x18278)"

echo "==== emac_field_dis ==="
echo -e "   emac_dis_cs\t\t: 			$(dma_r32_n  0x18140)"
echo -e "   emac_dis_ns\t\t: 			$(dma_r32_n  0x18144)"
echo -e "   rx_dis_debug0_num\t\t: 		$(dma_r32_n  0x18408)"
echo -e "   rx_dis_debug1_num\t\t: 		$(dma_r32_n  0x1840c)"


echo "==== emac_mng_filter ==="
echo -e "   emac_filter_cs\t\t: 			$(dma_r32_n  0x18148)"
echo -e "   emac_filter_ns\t\t: 			$(dma_r32_n  0x1814c)"

echo "==== emac_host_l2_filter ==="
echo -e "   host_filter_cs\t\t: 			$(dma_r32_n  0x18150)"
echo -e "   host_filter_ns\t\t: 			$(dma_r32_n  0x18154)"

echo "==== emac_pip_decap ==="
echo -e "   decap_cs\t\t: 				$(dma_r32_n  0x18158)"
echo -e "   emac_decap_ns\t\t: 				$(dma_r32_n  0x1815c)"
echo -e "   decap_pkt_in_num\t\t: 			$(dma_r32_n  0x182d0)"
echo -e "   decap_pkt_out_num\t\t: 			$(dma_r32_n  0x182d4)"
echo -e "   decap_dmac_out_num\t\t: 			$(dma_r32_n  0x182d8)"
echo -e "   decap_bmc_out_num\t\t: 			$(dma_r32_n  0x182dc)"
echo -e "   decap_sw_out_num\t\t: 			$(dma_r32_n  0x182e0)"
echo -e "   decap_mirror_out_num\t\t: 			$(dma_r32_n  0x182e4)"
echo -e "   decap_pkt_drop0_num\t\t: 			$(dma_r32_n  0x182e8)"
echo -e "   decap_pkt_drop1_num\t\t: 			$(dma_r32_n  0x182ec)"
echo -e "   decap_dmac_drop_num\t\t: 			$(dma_r32_n  0x182f0)"
echo -e "   decap_bmc_drop_num\t\t: 			$(dma_r32_n  0x182f4)"
echo -e "   decap_sw_drop_num\t\t: 			$(dma_r32_n  0x182f8)"
echo -e "   decap_rm_vlan_num\t\t: 			$(dma_r32_n  0x182fc)"

#echo -e "   port0_rxtrans_wdt_err\t\t: $(dma_r32_n  0x18908 ) "
#echo -e "   port0_rxtrans_code_err\t\t: $(dma_r32_n  0x1890c ) "
#echo -e "   port0_rxtrans_crc_err\t\t: $(dma_r32_n  0x18910 ) "
#echo -e "   port0_rxtrans_slen_err\t\t: $(dma_r32_n  0x18914 ) "
#echo -e "   port0_rxtrans_glen_err\t\t: $(dma_r32_n  0x18918 ) "
#echo -e "   port0_rxtrans_iph_err\t\t: $(dma_r32_n  0x1891c ) "
#echo -e "   port0_rxtrans_csum_err\t\t: $(dma_r32_n  0x18920 ) "
#echo -e "   port0_rxtrans_len_err\t\t: $(dma_r32_n  0x18924 ) "
#echo -e "   port0_rxtrans_cut_err\t\t: $(dma_r32_n  0x18928 ) "
#echo -e "   port0_rxtrans_except_bytes\t\t: $(dma_r32_n  0x1892c ) "
#echo -e "   port0_rxtrans_bytes_g1600\t\t: $(dma_r32_n  0x18930 ) "
#
#echo -e "   port1_rxtrans_wdt_err\t\t: $(dma_r32_n  0x18948 ) "
#echo -e "   port1_rxtrans_code_err\t\t: $(dma_r32_n  0x1894c ) "
#echo -e "   port1_rxtrans_crc_err\t\t: $(dma_r32_n  0x18950 ) "
#echo -e "   port1_rxtrans_slen_err\t\t: $(dma_r32_n  0x18954 ) "
#echo -e "   port1_rxtrans_glen_err\t\t: $(dma_r32_n  0x18958 ) "
#echo -e "   port1_rxtrans_iph_err\t\t: $(dma_r32_n  0x1895c ) "
#echo -e "   port1_rxtrans_csum_err\t\t: $(dma_r32_n  0x18960 ) "
#echo -e "   port1_rxtrans_len_err\t\t: $(dma_r32_n  0x18964 ) "
#echo -e "   port1_rxtrans_cut_err\t\t: $(dma_r32_n  0x18968 ) "
#echo -e "   port1_rxtrans_except_bytes\t\t: $(dma_r32_n  0x1896c ) "
#echo -e "   port1_rxtrans_bytes_g1600\t\t: $(dma_r32_n  0x18970 ) "
#
#echo -e "   port2_rxtrans_wdt_err\t\t: $(dma_r32_n  0x18988 ) "
#echo -e "   port2_rxtrans_code_err\t\t: $(dma_r32_n  0x1898c ) "
#echo -e "   port2_rxtrans_crc_err\t\t: $(dma_r32_n  0x18990 ) "
#echo -e "   port2_rxtrans_slen_err\t\t: $(dma_r32_n  0x18994 ) "
#echo -e "   port2_rxtrans_glen_err\t\t: $(dma_r32_n  0x18998 ) "
#echo -e "   port2_rxtrans_iph_err\t\t: $(dma_r32_n  0x1899c ) "
#echo -e "   port2_rxtrans_csum_err\t\t: $(dma_r32_n  0x189a0 ) "
#echo -e "   port2_rxtrans_len_err\t\t: $(dma_r32_n  0x189a4 ) "
#echo -e "   port2_rxtrans_cut_err\t\t: $(dma_r32_n  0x189a8 ) "
#echo -e "   port2_rxtrans_except_bytes\t\t: $(dma_r32_n  0x189ac ) "
#echo -e "   port2_rxtrans_bytes_g1600\t\t: $(dma_r32_n  0x189b0 ) "
#
#
#echo -e "   port2_rxtrans_wdt_err\t\t: $(dma_r32_n  0x189c8 ) "
#echo -e "   port2_rxtrans_code_err\t\t: $(dma_r32_n  0x189cc ) "
#echo -e "   port2_rxtrans_crc_err\t\t: $(dma_r32_n  0x189c0 ) "
#echo -e "   port2_rxtrans_slen_err\t\t: $(dma_r32_n  0x189d4 ) "
#echo -e "   port2_rxtrans_glen_err\t\t: $(dma_r32_n  0x189d8 ) "
#echo -e "   port2_rxtrans_iph_err\t\t: $(dma_r32_n  0x189dc ) "
#echo -e "   port2_rxtrans_csum_err\t\t: $(dma_r32_n  0x189e0 ) "
#echo -e "   port2_rxtrans_len_err\t\t: $(dma_r32_n  0x189e4 ) "
#echo -e "   port2_rxtrans_cut_err\t\t: $(dma_r32_n  0x189e8 ) "
#echo -e "   port2_rxtrans_except_bytes\t\t: $(dma_r32_n  0x189ec ) "
#echo -e "   port2_rxtrans_bytes_g1600\t\t: $(dma_r32_n  0x189f0 ) "
#
#echo "==== nic trans status ==="
#echo -e "   port0_rx_in_cnt\t\t: $(dma_r32_n  0x18900 ) "
#echo -e "   port0_rx_drop_cnt\t\t: $(dma_r32_n  0x18904 ) "
#echo -e "   port1_rx_in_cnt\t\t: $(dma_r32_n  0x18940 ) "
#echo -e "   port1_rx_drop_cnt\t\t: $(dma_r32_n  0x18944 ) "
#echo -e "   port2_rx_in_cnt\t\t: $(dma_r32_n  0x18980 ) "
#echo -e "   port2_rx_drop_cnt\t\t: $(dma_r32_n  0x18984 ) "
#echo -e "   port3_rx_in_cnt\t\t: $(dma_r32_n  0x189c0 ) "
#echo -e "   port3_rx_drop_cnt\t\t: $(dma_r32_n  0x189c4 ) "
#
#echo "==== nic 4to1 status ==="
#echo -e "   port0_rx_to_next_cnt\t\t: $(dma_r32_n  0x18220 ) "
#echo -e "   port1_rx_to_next_cnt\t\t: $(dma_r32_n  0x18224 ) "
#echo -e "   port2_rx_to_next_cnt\t\t: $(dma_r32_n  0x18228 ) "
#echo -e "   port3_rx_to_next_cnt\t\t: $(dma_r32_n  0x1822c ) "
#
#echo -e "   port0_rx_to_drop_cnt\t\t: $(dma_r32_n  0x18230 ) "
#echo -e "   port1_rx_to_drop_cnt\t\t: $(dma_r32_n  0x18234 ) "
#echo -e "   port2_rx_to_drop_cnt\t\t: $(dma_r32_n  0x18238 ) "
#echo -e "   port3_rx_to_drop_cnt\t\t: $(dma_r32_n  0x1823c ) "
#
#echo "==== nic parse status ==="
#echo -e "   port3_rx_in_cnt\t\t: $(dma_r32_n  0x18290 ) "
#echo -e "   port3_rx_out_cnt\t\t: $(dma_r32_n  0x18294 ) "
#
#echo "==== dma status ==="
#string=$(bar4_r32  0x110)
#strings=(${string//:/ })
#value=${strings[1]}
## bit 30:24
##echo -e "   rx stop ring id\t\t: ${value:0-8:2}"
#echo -e "   rx ring drop count\t\t: $(dma_r32_n  0x114 ) "
#
#echo "==== DMA head tail ==="
#
#for ring in $(seq 0  127)
#do
#    echo -e "queue$ring tx head\t: $(dma_r32_n  $(($ring*0x100 + 0x806c)) ) \t, tx_tail:  $(dma_r32_n  $(($ring*0x100 + 0x8070)) )  "
#done
#
#for ring in $(seq 0  127)
#do
#    echo -e "queue$ring rx head\t: $(dma_r32_n  $(($ring*0x100 + 0x803c)) ) \t, rx_tail:  $(dma_r32_n  $(($ring*0x100 + 0x8040)) )  "
#done
