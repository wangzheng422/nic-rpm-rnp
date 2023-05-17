#!/bin/bash

cwd=$(dirname $(readlink -f $0))

source $cwd/regfun.env


bar4_w32 $(( $1 )) $2

bar4_r32 $(( $1 ))
