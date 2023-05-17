###################################################################
# File Name   : memroy_check.sh
# Author      : dongyb
# Mail        : dongyibo100@qq.com
# Created Time: 2022-05-09
#=============================================================
#!/bin/bash


echo "==========$(date "+%Y%m%d%H%M")=============="
echo "total memory:"
free -h

echo "app memory:"
grep Pss /proc/[1-9]*/smaps | awk '{total+=$2}; END {print total}'

echo "buddy memory:"
cat /proc/buddyinfo | awk '{sum=0;for(i=5;i<=NF;i++) sum+=$i*(2^(i-5))};{total+=sum/256};{print $1 " " $2 " " $3 " " $4 "\t : " sum/256 "M"} END {print "total\t\t\t : " total "M"}'

echo "slab memory:"
cat /proc/meminfo | grep Slab
echo "..."
slabtop -o
echo "..."
cat /proc/slabinfo


