# nic-rpm-rnp

这里是为casa准备的，网卡的驱动rpm。据说是用了深圳联瑞的卡。华为的卡不单卖，要和服务器一起卖。

## 环境准备

我们要有一台linux主机，内核版本要和目标内核版本一致。

```bash
# on ocp cluster node
uname -a
# Linux sno.ytl.com 4.18.0-372.52.1.el8_6.x86_64 #1 SMP Fri Mar 31 06:22:44 EDT 2023 x86_64 x86_64 x86_64 GNU/Linux


subscription-manager release --set=8.6
subscription-manager repos \
    --enable="rhel-8-for-x86_64-baseos-tus-rpms"

dnf install -y kernel-modules-extra-4.18.0-372.52.1.el8_6 kernel-devel-4.18.0-372.52.1.el8_6 kernel-headers-4.18.0-372.52.1.el8_6


```

## 编译驱动

这里需要先编译好驱动
```bash
dnf install -y kernel-devel

cd rnp-nic-drv-<version>/rnp
./do_build.sh
# make install

```
然后复制到source目录
```bash
/bin/rm -f ~/rpmbuild/SRPMS/*
/bin/rm -f ~/rpmbuild/RPMS/x86_64/*
/bin/rm -f ~/rpmbuild/SOURCES/*

/bin/cp -f /root/nic-rpm-rnp/rnp-nic-drv-0.1.6.rc44-35c40ea/rnp/{*.ko,pci.ids} ~/rpmbuild/SOURCES/
```
然后运行编译，注意需要根据自己的需要，修改 ```~/rpmbuild/SPECS/driver.spec```
```bash
cd ~/rpmbuild/SPECS
rpmbuild -ba driver.spec
```

注意，不同版本内核，要编译不同的rpm

编译结果在 ```~/rpmbuild/RPMS/x86_64/*``` 里面

```bash

dmesg | grep rnp
# [   37.199692] rnp: loading out-of-tree module taints kernel.
# [   37.199706] rnp: loading out-of-tree module taints kernel.
# [   37.211162] rnp: module verification failed: signature and/or required key missing - tainting kernel
# [   37.222137] rnp: mucse 1/10/25/40 Gigabit PCI Express Network Driver - version 0.2.0 42f3895
# [   37.230682] rnp: Copyright (c) 2020-2023 mucse Corporation.
# [   37.236665] rnp: ====  add adapter queues:128 ====
# [   37.236735] rnp: [bar4]:00000000baac369f 9e200000 len=2 MB
# [   37.275561] rnp: rnp_mbx_get_capability: nic-mode:1 mac:2 adpt_cnt:1 lane_mask:0x1, phy_type: 0x6, pfvfnum:0x0, fw-version:0x00040009
# [   37.295770] rnp: rnp10 0000:3b:00.0: dma version:0x20210111, nic version:0x20201120, pfvfnum:0x0
# [   37.355722] rnp: dev mac:6c:b3:11:64:1b:76
# [   37.362406] rnp: ====  add adapter queues:128 ====
# [   37.362564] rnp: [bar4]:00000000ae8263ca 96000000 len=2 MB
# [   37.395632] rnp: rnp_mbx_get_capability: nic-mode:1 mac:2 adpt_cnt:1 lane_mask:0x1, phy_type: 0x6, pfvfnum:0x40, fw-version:0x00040009
# [   37.421642] rnp: rnp11 0000:3b:00.1: dma version:0x20210111, nic version:0x20201120, pfvfnum:0x40
# [   37.465796] rnp: dev mac:6c:b3:11:64:1b:77
# [   37.501612] rnp 0000:3b:00.0 ens1f0: renamed from eth0
# [   37.525360] rnp 0000:3b:00.1 ens1f1: renamed from eth1
# [   50.096477] rnp: msix mode is used
# [   50.101593] rnp 0000:3b:00.0: registered PTP clock
# [   50.160083] rnp: msix mode is used
# [   50.195281] rnp 0000:3b:00.1: registered PTP clock
# [   50.526988] rnp 0000:3b:00.0 ens1f0: NIC Link is Up 10 Gbps, Full Duplex, Flow Control: RX/TX
# [   51.031022] rnp 0000:3b:00.1 ens1f1: NIC Link is Up 10 Gbps, Full Duplex, Flow Control: RX/TX

ethtool -f ens1f0 N10G-X2-DC-2SFP+_0.5.2.12.img.bin 0


ethtool ens1f0
# Settings for ens1f0:
#         Supported ports: [ FIBRE ]
#         Supported link modes:   10000baseSR/Full
#         Supported pause frame use: Symmetric Receive-only
#         Supports auto-negotiation: Yes
#         Supported FEC modes: Not reported
#         Advertised link modes:  10000baseSR/Full
#         Advertised pause frame use: Symmetric
#         Advertised auto-negotiation: Yes
#         Advertised FEC modes: Not reported
#         Speed: 10000Mb/s
#         Duplex: Full
#         Auto-negotiation: off
#         Port: Direct Attach Copper
#         PHYAD: 0
#         Transceiver: internal
#         Supports Wake-on: d
#         Wake-on: d
#         Current message level: 0x00000001 (1)
#                                drv
#         Link detected: yes


ethtool -i ens1f0
# driver: rnp
# version: 0.2.0 42f3895
# firmware-version: 0.5.2.12 0x84100044
# expansion-rom-version:
# bus-info: 0000:3b:00.0
# supports-statistics: yes
# supports-test: yes
# supports-eeprom-access: no
# supports-register-dump: yes
# supports-priv-flags: yes


```