#!/bin/bash
cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env

eth_w32 0x8040 0xffffffff
