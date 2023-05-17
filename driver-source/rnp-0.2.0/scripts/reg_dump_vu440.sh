#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

dma_reg_dump()
{
    queue_idx=$1

    echo -e "\n=== queue$queue_idx enable =="
    r32 $(( $bar4_phy + 0x8010 + 0x100*$queue_idx  )) 7

    echo -e "\n=== queue$queue_idx rx =="
    r32 $(( $bar4_phy + 0x8030 + 0x100*$queue_idx )) 10

    echo -e "\n=== queue$queue_idx tx =="
    r32 $(( $bar4_phy + 0x8060 )) 11
}

echo -e "\n=== dma global  =="
r32 $(( $bar4_phy + 0x0000 )) 4

echo -e "\n=== axien enable =="
r32 $(( $bar4_phy + 0x0010 )) 2


echo -e "\n=== reg0   =="
r32 $(( $bar4_phy + 0x30000  )) 5

echo -e "\n=== ring-msix table   =="
r32 $(( $bar4_phy + 0xa4000  )) 16


echo -e "\n=== mac   =="
r32 $(( $bar4_phy + 0x60000  )) 3
r32 $(( $bar4_phy + 0x60000 + 0xd0  )) 1
r32 $(( $bar4_phy + 0x60000 + 0x70  )) 1
r32 $(( $bar4_phy + 0x60000 + 0x90  )) 1
r32 $(( $bar4_phy + 0x60000 + 0x120  )) 1


#echo -e "\n=== count register =="
#r32 $(( $bar4_phy + 0x0200  )) 40

# ring0
dma_reg_dump 0

# ring1
dma_reg_dump 1
