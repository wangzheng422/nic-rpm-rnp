#!/bin/bash

cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env


do_veb_dump()
{
    #for:98:03:9b:48:cd:80,  ral:0x9b48cd80 rah:0x80009803
    vf=$1
    port=${2:-0}
    echo -e "PORT$port VEB_MAC[$vf] LO  :   $( bar4_w32 $(( 0x80a0 + 4*$port + 0x100*$vf  )) 0 )"
    echo -e "PORT$port VEB_MAC[$vf] HI  :   $( bar4_w32 $(( 0x80b0 + 4*$port + 0x100*$vf  )) 0 )"
    echo -e "PORT$port VEB_RING[$vf]____:   $( bar4_w32 $(( 0x80d0 + 4*$port + 0x100*$vf  )) 0 )"
}


veb_dump()
{
    port=$1

    echo -e "\n\n === veb table ===\n"
    for idx in $(seq 0 31);
    do
        do_veb_dump $idx $port
    done
}

port=${1:-0}

veb_dump $port
#echo -e "default rx-ring\t: $( eth_r32  0x806c )"
