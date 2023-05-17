###################################################################
# File Name   : setup.sh
# Author      : dongyb
# Mail        : dongyibo100@qq.com
# Created Time: 2020-12-09
#=============================================================
#!/bin/bash
ethtool -L rnp00 combined 1
ethtool -L rnp10 combined 1
ifconfig rnp00 up
ifconfig rnp10 up
echo 00020000,00000000 > /sys/class/net/rnp10/queues/tx-0/xps_cpus
echo 49 > /proc/irq/160/smp_affinity_list
brctl addif br0 rnp00
brctl addif br0 rnp10

