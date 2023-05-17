#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env

reg=${1:-0}
shift

eth_r32 $((  $reg )) $@

