#!/bin/sh

\rm -rf /var/crash/*  || true

./do_build.sh uv3p-1ring  $@

dmesg -C
