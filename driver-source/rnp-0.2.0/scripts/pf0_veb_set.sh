#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

port=0
vf=63

veb_set()
{
    vf=$1
    port=${2:-0}

    bar4_w32 $(( 0x80a0 + 4*$port + 0x100*$vf  )) 0x313044f0
    bar4_w32 $(( 0x80b0 + 4*$port + 0x100*$vf  )) 0x0000004E
    bar4_w32 $(( 0x80d0 + 4*$port + 0x100*$vf  )) 0xbf06

    bar4_r32 $(( 0x80a0 + 4*$port + 0x100*$vf  )) 
    bar4_r32 $(( 0x80b0 + 4*$port + 0x100*$vf  ))
    bar4_r32 $(( 0x80d0 + 4*$port + 0x100*$vf  ))
}

echo === $i ==
veb_set 3


