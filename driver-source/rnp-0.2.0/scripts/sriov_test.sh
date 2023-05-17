###################################################################
# File Name   : sriov_test.sh
# Author      : dongyb
# Mail        : dongyibo100@qq.com
# Created Time: 2022-12-28
#=============================================================
#!/bin/bash
function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(date +%s%N)
    echo $(($num%$max+$min))
}

cnt=1
while :
do {
    date "+%D %T"
    echo "cnt$cnt"
    echo "start to rm/insmod"
    cd /home/dongyb/rnp-nic-drv/rnp
    rmmod rnp
    insmod rnp.ko

    echo "start to operate sriov"
    result=$(python3 -c 'import random; print(random.choice([0, 63]))' "$@")
    echo "operate $result"
    echo $result > /sys/bus/pci/devices/0000\:65\:00.0/sriov_numvfs &&\
    echo $result > /sys/bus/pci/devices/0000\:65\:00.1/sriov_numvfs &&\
    echo "to get current sriov status"
    cat /sys/bus/pci/devices/0000\:65\:00.0/sriov_numvfs &&\
    cat /sys/bus/pci/devices/0000\:65\:00.1/sriov_numvfs

    echo -e "\n"
    let cnt++
}
done

