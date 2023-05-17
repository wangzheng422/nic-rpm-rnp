#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

echo -e "\n=== axien enable =="
r32 $(( $bar4_phy + 0x0010 )) 2

echo -e "\n=== reg0   =="
r32 $(( $bar4_phy + 0x30000  )) 5

echo -e "\n=== dma0 queue0 rx/tx enable =="
r32 $(( $bar4_phy + 0x8010 )) 7

echo -e "\n=== dma0 rx queue 0 =="
r32 $(( $bar4_phy + 0x8030 )) 10

echo -e "\n=== dma0 tx queue 0 =="
r32 $(( $bar4_phy + 0x8060 )) 11

echo -e "\n=== mac   =="
r32 $(( $bar4_phy + 0x60000  )) 3
r32 $(( $bar4_phy + 0x60000 + 0xd0  )) 1
r32 $(( $bar4_phy + 0x60000 + 0x70  )) 1
r32 $(( $bar4_phy + 0x60000 + 0x90  )) 1
r32 $(( $bar4_phy + 0x60000 + 0x120  )) 1

echo -e "\n=== dma0 ring-msix table   =="
r32 $(( $bar4_phy + 0xa4000  )) 16

####################  dma1 #################

echo -e "\n=== dma1 rx queue 0 =="
r32 $(( $bar4_phy + 0x8030 + 0x100000 + 0x100*0 )) 10

echo -e "\n=== dam1 tx queue 0 =="
r32 $(( $bar4_phy + 0x8060 + 0x100000 + 0x100*0 )) 11

echo -e "\n=== dma1 rx queue 1 =="
r32 $(( $bar4_phy + 0x8030 + 0x100000 + 0x100*1 )) 10

echo -e "\n=== dam1 tx queue 1 =="
r32 $(( $bar4_phy + 0x8060 + 0x100000 + 0x100*1 )) 11

echo -e "\n=== dma1 ring-msix table   =="
r32 $(( $bar4_phy + 0xa4000 + 0x100000  )) 16

#echo -e "\n=== count register =="
#r32 $(( $bar4_phy + 0x0200  )) 40
