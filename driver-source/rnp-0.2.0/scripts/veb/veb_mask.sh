#!/bin/bash

cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env

bar4_w32 0x20 0xffffffff
bar4_w32 0x24 0x0000feff

echo "veb dmac_mask: $(bar4_r32 0x024)_$(bar4_r32 0x020)"
