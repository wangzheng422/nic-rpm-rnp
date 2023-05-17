#!/bin/bash
killall irqbalance
if [ $# == 0 ] ; then
                echo " USAGE: $0 ring_num cpu_start"
                exit 1
fi

ring_num=$1
cpu_start=$2

echo "setup irq with ring_num $ring_num start cpu $cpu_start"

dec2hex(){
        var=$1
        len_total=${#var}
        len=0
        while ((len<$len_total))
        do
                stop=$(($len+8))
                if (($stop>$len_total)); then
                        stop=$len_total
                        len_temp=$(($len_total-$len))
                else
                        len_temp=8
                fi
                #       echo var is $var $stop $len_temp
                temp=${var:0-$stop:$len_temp}
                #       echo temp is $temp
                ((len+=8))
                if [ ! -n "$result" ]; then
                        result="${temp}"
                else
                        result="${temp},${result}"
                fi
                #       echo now result is $result
        done
        echo $result
}

devices=$(lspci -d 8848: | awk -F ' ' '{print $1}')
cpu=$cpu_start

for DEV in ${devices[@]}
do

# get netname
pdev_sysfs_net=/sys/bus/pci/devices/$DEV/net/
if [ ! -d "$pdev_sysfs_net" ];then
        pdev_sysfs_net=/sys/bus/pci/devices/0000:$DEV/net/
fi
netnames=$(ls $pdev_sysfs_net)
for netname in ${netnames[@]}
do
        # change ring to 4
        ifconfig $netname up
        sudo ethtool -L $netname combined $ring_num
        ethtool --set-priv-flags $netname ft_padding on

        i=$(cat /proc/interrupts | grep $netname-TxRx-0 | awk -F ' ' '{print $1}')
        i=${i%?}
        for ((j=0; j<$ring_num; j++))
        do
                cpu_temp=$cpu
                tx_mask=
                while (($cpu_temp>63))
                do
                        tx_mask="${tx_mask}0000000000000000"
                        ((cpu_temp-=63))
                done
                if [ ! -n "$tx_mask" ]; then
                        tmp="$(echo $cpu_temp | awk '{print lshift(1,$cpu_temp)}')"
                        tx_mask=$(printf "%x" $tmp)
                else
                        tmp="$(echo $cpu_temp | awk '{print lshift(1,$cpu_temp)}')"
                        tmp=$(printf "%x" $tmp)
                        tx_mask="${tmp}${tx_mask}"
                fi
                tx_mask=$(dec2hex $tx_mask)

#echo setup irq $i tx_mask $tx_mask for $dev to cpu $cpu
echo $dev rx_irq $i $cpu_temp cpu $cpu_temp tx_mask $tx_mask
echo $cpu_temp > /proc/irq/$i/smp_affinity_list
echo $tx_mask > /sys/class/net/$netname/queues/tx-$j/xps_cpus
((i++))
((cpu++))
done
done
done

