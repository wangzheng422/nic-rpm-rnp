#!/bin/bash

cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env

level=0
RED="\e[31m"
YELO="\e[33m"
BLUE="\e[34m"
RESET="\e[39m"


echo "RAR table"
rar_dump()
{
    idx=$1
    echo  -e "$idx\t RAH:  $( eth_r32  $(( 0xa400 + 4*$idx)) ) $( eth_r32  $(( 0xa000 + 4*$idx)) )"
}

for i in $(seq 0 128)
do
    rar_dump $i
done
