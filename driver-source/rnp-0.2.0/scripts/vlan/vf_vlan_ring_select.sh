#!/bin/bash
cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env



vlan_to_ring()
{
    idx=$1
    vlan=$2
    ring=$3

    #pfv1vfb
    eth_w32 $(( 0xb600 + 4*$idx ))  $(( (1<<31)| $vlan ))
    eth_w32 $(( 0xb700 + 4*$idx )) $(($ring >>1))
}

vlan_to_ring 0 4 2
