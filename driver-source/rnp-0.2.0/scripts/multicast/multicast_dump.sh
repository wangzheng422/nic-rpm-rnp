#!/bin/bash

cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env

level=0
RED="\e[31m"
YELO="\e[33m"
BLUE="\e[34m"
RESET="\e[39m"

echo "== unicast table == "
eth_r32 0xa800 128

echo "== multicast table == "
eth_r32 0xac00 128

echo " mcstctrl: unicast[3]/multicast[2] enable $(eth_r32 0x9114)"
