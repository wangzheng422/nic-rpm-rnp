#!/bin/bash
DRV_DIR="$(pwd)"
rm -f ${DRV_DIR}/../dkms.conf
touch ${DRV_DIR}/../dkms.conf
script_dir=$(dirname $(readlink -f $0))
proj_top=$(readlink -f "${script_dir}/")
DRV_VERSION=$(grep 'define DRV_VERSION' $proj_top/../src/rnp_main.c  | awk '{gsub("\"","",$3) ;print $3}')
DRV_VERSION=${DRV_VERSION:0:5}
DRV_NAME=rnp
echo "MAKE=\"BUILD_KERNEL=\${kernelver} 'make' -C src KERNELDIR=/lib/modules/\${kernelver}/build\""  >> ${DRV_DIR}/../dkms.conf
echo "CLEAN=\"'make' clean\""  >> ${DRV_DIR}/../dkms.conf
echo "BUILT_MODULE_NAME=\"${DRV_NAME}"\" >> ${DRV_DIR}/../dkms.conf 
echo "BUILT_MODULE_LOCATION=\"src\"" >> ${DRV_DIR}/../dkms.conf
echo "DEST_MODULE_LOCATION=\"/updates\"" >> ${DRV_DIR}/../dkms.conf
echo "PACKAGE_NAME=rnp-dkms" >> ${DRV_DIR}/../dkms.conf
echo "PACKAGE_VERSION=${DRV_VERSION}" >> ${DRV_DIR}/../dkms.conf
echo "REMAKE_INITRD=no" >> ${DRV_DIR}/../dkms.conf
echo "AUTOINSTALL=\"yes\"" >> ${DRV_DIR}/../dkms.conf
