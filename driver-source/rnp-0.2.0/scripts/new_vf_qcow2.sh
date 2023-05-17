#!/bin/bash
dst=$1
qemu-img create -b centos7-amd.qcow2 -f qcow2 $dst
