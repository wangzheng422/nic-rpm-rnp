#!/bin/bash

#IOMMU=-device intel-iommu
IOMMU="-device intel-iommu"

QEMU=/data/sriov/qemu/qemu-5.1.0/x86_64-softmmu/qemu-system-x86_64

SLOT="0c:00.0"


#-device vfio-pci,host=${GPU}.0,bus=root.1,addr=00.0,multifunction=on

#modprobe pci_stub
#echo "1dab 7001" > /sys/bus/pci/drivers/pci-stub/new_id

modprobe vfio-pci
echo "1dab 7001" > /sys/bus/pci/drivers/vfio-pci/new_id

$QEMU -cpu host  \
    -M q35 \
	-smp 2 -m 3G \
    --enable-kvm \
    -device vfio-pci,host=$SLOT \
    -monitor stdio \
    -net nic -net user \
   -hda /data/sriov/pf0.qcow2 \
   --display vnc=:0 \
   $@
   #--display sdl \

echo -n "1dab 7001" > /sys/bus/pci/drivers/vfio-pci/remove_id
