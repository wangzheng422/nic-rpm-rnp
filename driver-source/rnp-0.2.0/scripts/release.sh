#!/bin/bash

do_gen_rpm=${1}
script_dir=$(dirname $(readlink -f $0))
proj_top=$(readlink -f "${script_dir}/../")

mkdir release 2> /dev/null || true

version_with_rc=$(grep 'define DRV_VERSION' $proj_top/src/rnp_main.c  | awk '{gsub("\"","",$3) ;print $3}')
DRV_VERSION=$(echo $version_with_rc | awk -F'.' '{printf("%d.%d.%d",$1,$2,$3);}')

git_commit=$(git rev-parse --short HEAD)
#prefix="rnp-${version}-$git_commit"
prefix_new="rnp-${DRV_VERSION}"
release_for_rc=rnp-${version_with_rc}-$git_commit

echo "version from src/rnp_main.c: DRV_VERSION: $version_with_rc $DRV_VERSION"
sed  -i "s/.*GIT_COMMIT.*/#define GIT_COMMIT \" ${git_commit}\"/g" src/version.h
sed  -i "s/.*PACKAGE_VERSION.*/PACKAGE_VERSION=${DRV_VERSION}/g" dkms.conf
sed  -i "s/.*Version:.*/Version: ${DRV_VERSION}/g" rnp.spec

out_file_new="$(readlink -f "${proj_top}/release/rnp-${DRV_VERSION}.tar.gz")"
out_file_for_rc="$(readlink -f "${proj_top}/release/${release_for_rc}.tar.gz")"

cd $proj_top
git commit -am "release: $prefix_new $git_commit"

git archive --format=tar.gz --prefix="${release_for_rc}/" -o $out_file_for_rc  HEAD ${proj_top}
git archive --format=tar.gz --prefix="${prefix_new}/" -o $out_file_new  HEAD ${proj_top}
git tag -d $version_with_rc || true
git tag $version_with_rc

if [ ! -z "$do_gen_rpm" ];then
# todo generate rpm
output_rpm=$(whereis rpmbuild | wc -l)
if [ ${output_rpm} -gt 0 ];then
		echo "build rpm: $out_file_new"
		rpmbuild -tb $out_file_new
		rpmbuild -ts $out_file_new 
		rpmbuild -ta $out_file_new 
	else
		echo "rpmbuild not exist .. skip"
	fi

fi

echo $out_file_new
echo $out_file_for_rc
