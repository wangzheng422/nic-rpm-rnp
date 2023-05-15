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

/bin/cp -f ~/rnp-nic-drv-0.1.6.rc12-98499a6/rnp/*.ko ~/rpmbuild/SOURCES/
```
然后运行编译，注意需要根据自己的需要，修改 ```~/rpmbuild/SPECS/driver.spec```
```bash
cd ~/rpmbuild/SPECS
rpmbuild -ba driver.spec
```

注意，不同版本内核，要编译不同的rpm

编译结果在 ```~/rpmbuild/RPMS/x86_64/*``` 里面