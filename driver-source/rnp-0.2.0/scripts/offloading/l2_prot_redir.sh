#!/bin/bash

cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env

#layer2_etqf0:  0x9200  : 0x80000001
#layer2_etqs0:  0x9240  : 0x70680000
ICMP_PROT=0x0

l2_rule()
{
    idx=$1
    prot=$2
    ring=$3

    eth_w32 $((0x9200 + 4*$idx)) $(( (1<<31) | $prot ))
    eth_w32 $((0x9240 + 4*$idx)) $(( (1<<30) | ($ring << 20)  ))
}
l2_disable()
{
    idx=$1
    eth_w32 $((0x9200 + 4*$idx)) 0x0
}


# open redir_en
eth_w32 0x8030 1
# host filter en
eth_w32 0x801c 1


# ip to ring 2
l2_rule 0 0x0800 2

echo "L2 DUMP"
eth_r32 0x9200 16
eth_r32 0x9240 16
