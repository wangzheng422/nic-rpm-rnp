#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

echo -e "rss table:  "

bar4_r32 $((0x1e000)) 128
