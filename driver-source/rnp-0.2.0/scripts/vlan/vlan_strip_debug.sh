#!/bin/bash
cwd=$(dirname $(readlink -f $0))/../

source $cwd/regfun.env

echo -e " $(eth_r32 0x801c), expect 1"
echo -e " $(eth_r32 0x8030), expect 1"
echo -e " $(eth_r32 0x92a0), expect 8"
echo -e " $(eth_r32 0x9110), expect 0x400"
echo -e " $(eth_r32 0x9114), expect 0x4"
echo -e " $(eth_r32 0x9118), expect 0x40000000"
echo -e " $(eth_r32 0xb5f8), expect 0x1"
echo -e " $(eth_r32 0xa1f8), expect 0x5e000001"
echo -e " $(eth_r32 0xa5f8), expect 0x80001000"
echo -e " $(eth_r32 0x8040), expect 0xcc"
echo -e " $(eth_r32 0xb000), expect 0x11"
