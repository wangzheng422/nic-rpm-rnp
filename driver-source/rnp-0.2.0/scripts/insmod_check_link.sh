#!/bin/bash


tool_dir=$(dirname $(readlink -f $0))
total_cnt=1
port0=eth2
port2=eth3

echo $tool_dir


rmmod rnp

while true
do
    echo ==== $total_cnt ===
    dmesg -C
    insmod $tool_dir/../rnp.ko

    sleep 1
    deves=$(lshw -c network -businfo -numeric -quiet | grep '8848:' |awk '{ print $2}')

    if [ -z "$deves" ];then
        break;
    fi

    for dev in $deves
    do
        cnt=$(ifconfig $dev |grep RUNN | wc -l )
        if [ $cnt -ne 1 ];then
            echo "$dev not ruinng:$cnt"
            break;
        else
            echo "$dev is ruinng"
        fi
    done
    total_cnt=$(( ${total_cnt} + 1 ))

    rmmod rnp
done
