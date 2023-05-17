#!/bin/bash
# ./rd_reg.sh device r|w bar reg value

if [ $# == 0 ] ; then
	echo " USAGE: $0 device r|w bar reg value"
	exit 1
fi
cwd=$(dirname $(readlink -f $0))
source $cwd/regfun.env
reg=${4:-0}
dev=$1
bar=$3
echo "bar is $bar, dev is $dev reg is $reg"
case $bar in
	'0')
	if [ $2 == 'r' ]
	then
	echo "read bar 0"
	bar0_r32 $(( $reg )) $5 $6
	else 
	echo "write bar 4"
	bar0_w32 $(( $reg )) $5 $6
	fi
	;;
	'2')
	if [ $2 == 'r' ]
	then
	echo "read bar 2"
	bar2_r32 $(( $reg )) $5 $6
	else 
	echo "write bar 2"
	bar2_w32 $(( $reg )) $5 $6
	fi
	;;
	'4')
	if [ $2 == 'r' ]
	then
	echo "read bar 4"
	bar4_r32 $(( $reg )) $5 $6
	else 
	echo "write bar 4"
	bar4_w32 $(( $reg )) $5 $6
	fi
	;;
	*)
	echo "bar not support"
esac

