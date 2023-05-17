#!/bin/bash
cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env



# vlan filter table: 4096 bits. each bit for 1 vlan
vlan=3
reg_off=$((  vlan / 32 ))
bit_off=$(( ))

set_bit()
{
    idx=$1
    reg_off=$(( $idx  ))
}

eth_w32 0xB000 0xffffffff

# vlan filter enable
eth_w32 0x9118 $((1<<30))
