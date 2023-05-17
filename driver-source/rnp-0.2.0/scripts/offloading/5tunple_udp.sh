#!/bin/bash

cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env

#layer2_etqf0:  0x9200  : 0x80000001
#layer2_etqs0:  0x9240  : 0x70680000
ICMP_PROT=0x0

_5tunple_rule()
{
    idx=$1
    ring=$2
    sip=$3
    dip=$4
    sport=$5
    dport=$6

    eth_w32 $((0xc000 + 4*$idx)) $sip
    eth_w32 $((0xc400 + 4*$idx)) $dip
    eth_w32 $((0xc800 + 4*$idx)) $(( ($dport << 16) | $sport ))
    eth_w32 $((0xcc00 + 4*$idx)) $((  (1<<31) | (1<<28)  ))
    eth_w32 $((0xd000 + 4*$idx)) $(( $ring << 16  ))
    
}

# open redir_en
eth_w32 0x8030 1
# host filter en
eth_w32 0x801c 1


# udp to ring 2
idx=0
ring=2
prot=$(( 0x11 ))
eth_w32 $((0xcc00 + 4*$idx)) $(( (1<<31) | (0<<29) | (1<<28) | (1<<27)| (1<<26) | (1<<25) | ($prot << 16) | (3) ))
eth_w32 $((0xd000 + 4*$idx)) $(( (1<<30) |  ( $ring << 20 )  ))
