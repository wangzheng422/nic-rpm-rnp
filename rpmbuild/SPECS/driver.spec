Name:           rnp-nic-drv
Version:        0.1.6.rc12_98499a6
Release:        1%{?dist}
Summary:        NIC driver for your hardware

License:        GPL
URL:            https://www.example.com/your-nic-driver
#Source0:        %{name}-%{version}.tar.gz

BuildRequires:  kernel-devel
Requires:       kernel >= 5.14.0

%description
This package provides the NIC driver for your hardware.

#获取当前环境的内核版本号
%define version %(uname -r)


%install
#1、RPM_BUILD_ROOT为此次工作的路径,以i40e驱动为例
rm -rf ${RPM_BUILD_ROOT}
#2、新建驱动模块的路径
mkdir -p ${RPM_BUILD_ROOT}/lib/modules/%{version}/updates/drivers/net/ethernet/mucse/rnp/
#3、将要安装的驱动模块复制到对应的目录下
cp ../SOURCES/rnp.ko ${RPM_BUILD_ROOT}/lib/modules/%{version}/updates/drivers/net/ethernet/mucse/rnp/


%clean
#清理工作目录
rm -rf ${RPM_BUILD_ROOT}

%files
#在这里放要拷贝到rpm包中的文件（驱动模块）
#1、对文件进行权限设置
%defattr(644, root, root)
#2、即为在系统中安装的路径
/lib/modules/%{version}/updates/drivers/net/ethernet/mucse/rnp/rnp.ko


%pre
#执行install之前要执行的命令
/sbin/depmod -a


%post
#命令执行后要执行的命令
#1、重新生成依赖关系
/sbin/depmod -a
#2、重新生成initramfs文件，将新的驱动写入initramfs文件中；
# dracut --force


%changelog
* Tue Apr 11 2023 Your Name <your@email.com> - 1.0-1
- Initial RPM release