#!/bin/bash

cwd=$(dirname $(readlink -f $0))

dumper=/tmp/rnp_regdump
gcc $cwd/rnp_regdump.c -o $dumper

$dumper
