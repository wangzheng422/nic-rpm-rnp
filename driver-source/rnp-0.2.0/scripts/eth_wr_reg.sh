#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env


eth_w32 $(( $1 )) $2

eth_r32 $(( $1 ))
