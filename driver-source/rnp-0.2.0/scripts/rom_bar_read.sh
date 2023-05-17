#/bin/bash

if [ -z $1 ];then
    pci_dev="0a:00.0"
else
    pci_dev=$1
fi

#1. 查看rom-bar地址
rom_bar_phy=$(( 0x$(setpci  -s $pci_dev ROM_ADDRESS) & ~(0xff) ))
echo $rom_bar_phy

#2. 使能rom-bar
setpci -s $pci_dev  ROM_ADDRESS=00000001:00000001


#3. 使能 设备的 master-enable
echo 1 > /sys/bus/pci/devices/0000:$pci_dev/enable


#4. 访问 rom-bar
devmem2  $(( $rom_bar_phy + 0x0)) w
