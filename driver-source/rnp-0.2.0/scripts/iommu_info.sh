###################################################################
# File Name   : iommu_info.sh
# Author      : dongyb
# Mail        : dongyibo100@qq.com
# Created Time: 2022-10-08
#=============================================================
#!/bin/bash
for d in $(find /sys/kernel/iommu_groups/ -type l | sort -n -k5 -t/); do
    n=${d#*/iommu_groups/*}; n=${n%%/*}
    printf 'IOMMU Group %s ' "$n"
    lspci -nns "${d##*/}"
done;

