###################################################################
# File Name   : buildall.sh
# Author      : dongyb
# Mail        : dongyibo100@qq.com
# Created Time: 2022-05-22
#=============================================================
#!/bin/bash
kernels=$(ls  /usr/src/ | grep generic)
rm -rf build_log
mkdir build_log
cd ..
cwd=$(dirname $(readlink -f $0))
for kernel in ${kernels[@]}
do
echo "build $kernel"
./do_build.sh ksrc=/usr/src/$kernel > $cwd/tools/build_log/$kernel.log 2>&1
done

kernels=$(ls  /usr/src/kernels)
for kernel in ${kernels[@]}
do
echo "build $kernel"
./do_build.sh ksrc=/usr/src/kernels/$kernel > $cwd/tools/build_log/$kernel.log 2>&1
done

