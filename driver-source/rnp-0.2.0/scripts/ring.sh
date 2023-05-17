#!/bin/bash

function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(date +%s%N)
    echo $(($num%$max+$min))
}

function check_time_out(){
a=$(dmesg | grep "Fake Tx hang " | wc -l)
if [ ${a} -gt 0 ];then
#stop
echo "stop shell"
((count++))
dmesg >> log1
#exit 1
fi
}

function check_wait_tx_done_time_out(){
a=$(dmesg | grep "wait tx done timeout" | wc -l)
if [ ${a} -gt 0 ];then
#stop
echo "stop shell"
((count1++))
dmesg >> log1
#exit 1
fi
#dmesg >> log_all
dmesg -c

}


count=0
count1=0
i=0
while :
do
echo "Fake Tx hang $count $count1"
date +%T >> log1
for dev in {"enp179s0f0","enp179s0f1","enp179s0f2","enp179s0f3"}
#for dev in {"p4p1",}
do
rnd=$(rand 256 4096)
echo "start of $dev" >> log1
echo "change to 256" >> log1
ethtool -G $dev rx 256 tx 256
check_time_out
check_wait_tx_done_time_out
sleep 5s
echo "change to 4094" >> log1
ethtool -G $dev rx 4094 tx 4094
check_time_out
check_wait_tx_done_time_out
sleep 5s
echo "change to $rnd"
ethtool -G $dev rx $rnd tx $rnd
check_time_out
check_wait_tx_done_time_out
sleep 5s
echo "change to 512" >> log1
ethtool -G $dev rx 512 tx 512
check_time_out
check_wait_tx_done_time_out
sleep 5s
rnd1=$(rand 1 8)
echo change ring num to $rnd1 >> log1
ethtool -L $dev combined $rnd1
check_time_out
check_wait_tx_done_time_out
sleep 5s

if ((i%3));then
ethtool -A $dev tx off rx off
else
ethtool -A $dev tx on rx on
fi
sleep 5s

done

((i++))
if ((i%2));then
echo "close sriov"
echo 0 > /sys/bus/pci/devices/0000\:b3\:00.0/sriov_numvfs;echo 0 > /sys/bus/pci/devices/0000\:b3\:00.1/sriov_numvfs;echo 0 > /sys/bus/pci/devices/0000\:b3\:00.2/sriov_numvfs;echo 0 > /sys/bus/pci/devices/0000\:b3\:00.3/sriov_numvfs
#echo 0 > /sys/bus/pci/devices/0000\:17\:00.0/sriov_numvfs
sleep 10
else
echo "open sriov"
#echo 7 > /sys/bus/pci/devices/0000\:17\:00.0/sriov_numvfs
echo 7 > /sys/bus/pci/devices/0000\:b3\:00.0/sriov_numvfs;echo 7 > /sys/bus/pci/devices/0000\:b3\:00.1/sriov_numvfs;echo 7 > /sys/bus/pci/devices/0000\:b3\:00.2/sriov_numvfs;echo 7 > /sys/bus/pci/devices/0000\:b3\:00.3/sriov_numvfs
fi


done

#while :
#do
#date +%T
#rnd=$(rand 256 4096)
#echo $rnd
#echo "start of p4p1"
#ethtool -G enp101s0f0 rx 256 tx 256
#check_time_out
#sleep 10s
#ethtool -G enp101s0f0 rx 4094 tx 4094
#check_time_out
#sleep 10s
#ethtool -G enp101s0f0 rx $rnd tx $rnd
#check_time_out
#sleep 10s
#ethtool -G enp101s0f0 rx 512 tx 512
#check_time_out
#sleep 10s
#echo "End of enp101s0f0"
#echo "start of enp101s0f1"
#ethtool -G enp101s0f1 rx 256 tx 256
#check_time_out
#sleep 10s
#ethtool -G enp101s0f1 rx 4094 tx 4094
#check_time_out
#sleep 10s
#ethtool -G enp101s0f1 rx $rnd tx $rnd
#check_time_out
#sleep 10s
#ethtool -G enp101s0f1 rx 512 tx 512
#check_time_out
#sleep 10s
#echo "End of enp101s0f1"
#echo "start of enp101s0f2"
#ethtool -G enp101s0f2 rx 256 tx 256
#check_time_out
#sleep 10s
#ethtool -G enp101s0f2 rx 4094 tx 4094
#check_time_out
#sleep 10s
#ethtool -G enp101s0f2 rx $rnd tx $rnd
#check_time_out
#sleep 10s
#ethtool -G enp101s0f2 rx 512 tx 512
#check_time_out
#sleep 10s
#echo "End of enp101s0f2"
#echo "start of enp101s0f3"
#ethtool -G enp101s0f3 rx 256 tx 256
#check_time_out
#sleep 10s
#ethtool -G enp101s0f3 rx 4094 tx 4094
#check_time_out
#sleep 10s
#ethtool -G enp101s0f3 rx $rnd tx $rnd
#check_time_out
#sleep 10s
#ethtool -G enp101s0f3 rx 512 tx 512
#check_time_out
#sleep 10s
#echo "End of enp101s0f3"
#done

