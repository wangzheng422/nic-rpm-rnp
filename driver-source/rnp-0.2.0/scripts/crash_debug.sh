#!/bin/bash

#yum install --enablerepo=base-debuginfo kernel-debuginfo-$(uname -r) kernel-debuginfo-common-$(uname -m)-$(uname -r) kernel-devel-$(uname -r) crash
cwd=$(dirname $(readlink -f $0))

RC=/tmp/crash.rc

echo "usage: #dis -l <fun>:<off> to see lines case crash"

cat <<EOF> $RC
mod -s rnp $(readlink -f $cwd/../rnp.ko)
EOF

vmcore=/var/crash/$(ls -t /var/crash/ | head -n 1)/vmcore
vmlinux=/usr/lib/debug/lib/modules/$(uname  -r)/vmlinux

echo "vmlinux:$vmlinux"
echo "vmcore:$vmcore"

crash  $vmlinux $vmcore -i $RC
