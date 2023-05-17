###################################################################
# File Name   : tx_packet_1_ring.sh
# Author      : dongyb
# Mail        : dongyibo100@qq.com
# Created Time: 2021-11-16
#=============================================================
#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

echo -e "\n=== dma head tail=="
r32 $(( $bar4_phy + 0x806c )) 2
echo -e "\n=== dma from tso"
r32 $(( $bar4_phy + 0x234 ))
echo -e "\n=== dma to mac"
r32 $(( $bar4_phy + 0x244 ))
echo -e "\n=== nic (tx no-drop)"
r32 $(( $bar4_phy + 0x10250 ))
echo -e "\n=== mac "
echo -e "\n=== pause send "
r32 $(( $bar4_phy + 0x10894 )) 2
echo -e "\n=== mac send "
r32 $(( $bar4_phy + 0x10834 )) 12




