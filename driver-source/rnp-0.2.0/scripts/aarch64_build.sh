#!/bin/bash

if [ -z $1 ];then
    echo "Usage: $0 <kernel_src_dir> [other makefile options]"
    exit -1
fi

cwd=$(dirname $(readlink -f $0))
cd $cwd/../

mv Makefile Makefile.bak

cp $cwd/makefile2 Makefile

KERNELDIR=${1}
export KERNELDIR
shift
echo "KERNEL_SRC=$KERNELDIR"

make $@ || true

mv Makefile.bak Makefile
