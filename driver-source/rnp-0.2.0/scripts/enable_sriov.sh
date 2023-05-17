#!/bin/bash

cnt=${2:-3}
#pf=${2:-7001}

devices=$(lspci -d 8848: | awk -F ' ' '{print $1}')
i=0
for DEV in ${devices[@]}
do
if [ $i == $1 ]
then
	break

fi
((i++))
done

cwd=$(dirname $(readlink -f $0))
source $cwd/regfun.env

echo $DEV
#SLOT=$( lspci -d 1dab:$pf | awk '{print $1}' )
pdev_sysfs=/sys/bus/pci/devices/$DEV
echo $cnt > $pdev_sysfs/sriov_numvfs


lspci -d 8848:
