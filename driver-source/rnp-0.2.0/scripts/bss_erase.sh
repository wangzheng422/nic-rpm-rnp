#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

echo -e "erase rss table:  "

for i in $(seq 0 127);
do
    bar4_w32 $((0x1e000 + $i*4 )) 0
done

echo "= erase done ="

bar4_r32 $((0x1e000 )) 128
