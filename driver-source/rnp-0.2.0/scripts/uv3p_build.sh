#!/bin/bash

\rm -rf /var/crash/*  || true

./do_build.sh uv3p  $@

dmesg -C
