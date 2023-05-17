#!/bin/bash

# rnp_common.h enum RNP_LOG_EVT
log_opt=(
	"MBX_IN"
	"MBX_OUT" 
	"MBX_MSG_IN"
	"MBX_MSG_OUT"
	"LINK_EVENT"
	"ADPT_STAT"
	"MBX_ABLI"
	"MBX_LINK_STAT"
	"MBX_IFUP_DOWN"
	"MBX_LOCK"
	"ETHTOOL"
)

idx=0
for str in ${log_opt[@]}; do
  echo "[$idx] $str"
  idx=$(($idx + 1))
done

read -p "chose one: " choice
op="on"
read -p "option:[on|off] " op


v_old=$(cat /sys/module/rnp/parameters/rnp_loglevel)
echo "idx:$choice op:$op "

if [ "$op" == "off" ];then
	v=$(($v_old & ~( 1<< $choice ) ))
else
	v=$(($v_old | ( 1<< $choice ) ))
fi
printf "0x%x -> 0x%x\n" $v_old $v

echo $v > /sys/module/rnp/parameters/rnp_loglevel