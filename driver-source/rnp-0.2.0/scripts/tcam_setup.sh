###################################################################
# File Name   : tcam_setup.sh
# Author      : dongyb
# Mail        : dongyibo100@qq.com
# Created Time: 2022-11-28
#=============================================================
#!/bin/bash
for j in {0..1}
do
# set tcam_en (1 -- > 0x18024)
./rd_reg.sh $j w 4 0x18024 1
# set tcam_config_en (1 -- > 0x38050)
./rd_reg.sh $j w 4 0x38050 1
# set tcam mode ( 2 --> 0xe0000)
./rd_reg.sh $j w 4 0xe0000 2
# set tcam cache (0 --> 0xe0004)
./rd_reg.sh $j w 4 0xe0004 0
# 4096 
start=0xc0000
i=0
for i in {0..4095}
do
vaule=$(($start+$i*16))
./rd_reg.sh $j w 4 $vaule 0
vaule=$(($start+$i*16+4))
./rd_reg.sh $j w 4 $vaule 0
vaule=$(($start+$i*16+8))
./rd_reg.sh $j w 4 $vaule 0
vaule=$(($start+$i*16+12))
./rd_reg.sh $j w 4 $vaule 0
# set sdpqf (0 --> 0xc0000)
# set daqf (0 --> 0xc0004)
# set saqf (0 --> 0xc0008)
# set apqf (0 --> 0xc000c)
#echo value is $vaule
done
./rd_reg.sh $j w 4 0xe0000 1
# set tcam mode ( 1 --> 0xe0000)
done
