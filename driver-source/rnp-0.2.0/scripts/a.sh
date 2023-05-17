#!/bin/bash

i=1

cd $(dirname $(readlink -f $0))

while true
do

    echo ==== $i ===
    rmmod rnp  || true

    insmod ../rnp.ko; 
    sleep 10 ; 

    ifconfig |grep RUNN 

    cnt=$(ifconfig |grep RUNN | wc -l)
    if [ $cnt -ne 4 ];then
        exit -1
    fi

    i=$(( $i + 1 ))
done
