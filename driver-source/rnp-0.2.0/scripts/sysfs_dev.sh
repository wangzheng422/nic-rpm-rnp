#!/bin/bash



pdev_sysfs_path()
{
    vendor=${1:-0x1dab}
    device=${2:-0x7001}

    for pdev in $(ls /sys/bus/pci/devices );
    do
        if [ "$(cat /sys/bus/pci/devices/$pdev/vendor)" == $vendor ];then
            if [ "$(cat /sys/bus/pci/devices/$pdev/device)" == $device ];then
                echo "/sys/bus/pci/devices/$pdev"
            fi
        fi
    done
}
pdev_sysfs_path 0x1dab 0x7001
