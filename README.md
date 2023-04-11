# nic-rpm-rnp

这里是为casa准备的，网卡的驱动rpm。据说是用了深圳联瑞的卡。华为的卡不单卖，要和服务器一起卖。

这里需要先编译好驱动
```bash
cd rnp-nic-drv-<version>/rnp
./do_build.sh
make install

```
然后复制到source目录
```bash
/bin/cp -f ~/rnp-nic-drv-0.1.6.rc44-35c40ea/rnp/{*.ko,pci.ids} ~/rpmbuild/SOURCES/
```
然后运行编译
```bash
cd ~/rpmbuild/SPECS
rpmbuild -ba driver.spec
```

注意，不同版本内核，要编译不同的rpm