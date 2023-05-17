###################################################################
# File Name   : destroy_bond.sh
# Author      : dongyb
# Mail        : dongyibo@qq.com
# Created Time: 2021-01-19
#=============================================================
#!/bin/bash
ip link set rnp00 nomaster
ip link set rnp10 nomaster
ip link delete bond1
ifconfig rnp00 up
ifconfig rnp10 up
systemctl start NetworkManager.service

