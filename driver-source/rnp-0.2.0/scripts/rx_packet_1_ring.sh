###################################################################
# File Name   : tx_packet_1_ring.sh
# Author      : dongyb
# Mail        : dongyibo100@qq.com
# Created Time: 2021-11-16
#=============================================================
#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

echo -e "\n=== mac receive "
r32 $(( $bar4_phy + 0x10940 )) 12
echo -e "\n=== pause receive "
r32 $(( $bar4_phy + 0x10988 )) 2
echo -e "\n=== nic receive"
r32 $(( $bar4_phy + 0x18900 )) 13
echo -e "=== 4to1 gather"
r32 $(( $bar4_phy + 0x18220 ))
echo -e "=== parse"
r32 $(( $bar4_phy + 0x18250 )) 2
r32 $(( $bar4_phy + 0x18288 )) 2
echo -e "=== decap in/out"
r32 $(( $bar4_phy + 0x182d0 )) 5
echo -e "=== flowctrl in/ out"
r32 $(( $bar4_phy + 0x18320 )) 5
echo -e "=== dma mac in/ out"
r32 $(( $bar4_phy + 0x264 )) 2
echo -e "=== dma switch in/ out"
r32 $(( $bar4_phy + 0x26c )) 2
echo -e "=== dma rx head/tail"
r32 $(( $bar4_phy + 0x803c )) 2
echo -e "=== dma rx drop"
r32 $(( $bar4_phy + 0x114 )) 





