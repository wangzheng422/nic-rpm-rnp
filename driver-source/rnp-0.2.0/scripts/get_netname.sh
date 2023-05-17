#!/bin/bash

devices=$(lspci -d 8848: | awk -F ' ' '{print $1}')
for DEV in ${devices[@]}
do
pdev_sysfs_net=/sys/bus/pci/devices/0000:$DEV/net/
if [ ! -d "$pdev_sysfs_net" ];then
pdev_sysfs_net=/sys/bus/pci/devices/$DEV/net/
fi
netnames=$(ls $pdev_sysfs_net)
for netname in ${netnames[@]}
do
echo "$DEV net name $netname"
done
done
