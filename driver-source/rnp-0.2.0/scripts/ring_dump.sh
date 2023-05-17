#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env
ring_num=${1:-0}

ring_dump()
{
    ring=$1

    echo -e "\n=== queue$ring rx/tx enable =="
    r32 $(( $bar4_phy + 0x8010 + 0x100*$ring )) 7

    echo -e "\n=== queue$ring rx regs =="
    r32 $(( $bar4_phy + 0x8030 + 0x100*$ring )) 10

    echo -e "\n=== queue$ring tx regs =="
    r32 $(( $bar4_phy + 0x8060 + 0x100*$ring )) 11
}


echo -e "\n=== default rx ring=="
r32 $(( $bar4_phy + 0x10000 + 0x806c )) 

echo -e "\n=== dma global  =="
r32 $(( $bar4_phy + 0x0000 )) 4

echo -e "\n=== axien enable =="
r32 $(( $bar4_phy + 0x0010 )) 2


echo -e "\n=== reg0   =="
r32 $(( $bar4_phy + 0x30000  )) 5

echo -e "\n=== mac   =="
r32 $(( $bar4_phy + 0x60000  )) 3
r32 $(( $bar4_phy + 0x60000 + 0xd0  )) 1
r32 $(( $bar4_phy + 0x60000 + 0x70  )) 1
r32 $(( $bar4_phy + 0x60000 + 0x90  )) 1
r32 $(( $bar4_phy + 0x60000 + 0x120  )) 1

echo -e "\n=== ring-msix table   =="
r32 $(( $bar4_phy + 0xa4000  )) 14

echo -e "\n mac0_rx $(r32 $(( $bar4_phy + 0x264 )))"

ring_dump $ring_num
