###################################################################
# File Name   : check_tx_start.sh
# Author      : dongyb
# Mail        : dongyibo@qq.com
# Created Time: 2022-03-02
#=============================================================
#!/bin/bash
i=0
base=0x8018
for i in {0..127}
do
address=$base
let address+=i*256
./rd_reg.sh 0 r 4 $address 1
#echo value is $address
done

