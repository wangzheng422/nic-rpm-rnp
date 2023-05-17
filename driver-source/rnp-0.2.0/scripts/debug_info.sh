#!/bin/bash
# ./rd_reg.sh device r|w bar reg value

if [ $# == 0 ] ; then
	echo " USAGE: $0 device ring_info ring_num"
	echo " USAGE: $0 device ring_desc ring_num desc_num"
	exit 1
fi
cwd=$(dirname $(readlink -f $0))
source $cwd/regfun.env
reg=${4:-0}
dev=$1
cmd=$2
case $cmd in
	'ring_info')
	tx_ring_info $3
	;;
	'ring_desc')
	tx_desc_info $3 $4
	;;
	*)
	echo "cmd not support"
esac

