#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must run this with superuser priviliges.  Try \"sudo ./dkms-install.sh\"" 2>&1
  exit 1
else
  echo "About to run dkms install steps..."
fi

DRV_DIR="$(pwd)"
DRV_NAME=rnp
script_dir=$(dirname $(readlink -f $0))
proj_top=$(readlink -f "${script_dir}/")
DRV_VERSION=$(grep 'define DRV_VERSION' $proj_top/../src/rnp_main.c  | awk '{gsub("\"","",$3) ;print $3}')
DRV_VERSION=${DRV_VERSION:0:5}

cp -r ${DRV_DIR}/../ /usr/src/${DRV_NAME}-${DRV_VERSION}

dkms add -m ${DRV_NAME} -v ${DRV_VERSION}
dkms build -m ${DRV_NAME} -v ${DRV_VERSION}
dkms install -m ${DRV_NAME} -v ${DRV_VERSION}
RESULT=$?

echo "Finished running dkms install steps."

exit $RESULT
