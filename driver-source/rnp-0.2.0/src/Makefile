# SPDX-License-Identifier: GPL-2.0
# Copyright(c) 1999 - 2021 Mucse Corporation.

ifneq ($(KERNELRELEASE),)
# kbuild part of makefile
#
# Makefile for the Mucse(R) 10GbE PCI Express Linux Network Driver
#
	EXTRA_CFLAGS += -I./include/ -I./ -I./base -DCONFIG_RNP_FPGA 
	#EXTRA_CFLAGS += -Wno-unused-function -Wno-unused-variable -Wno-unused-label
	EXTRA_CFLAGS += -g -O3
	EXTRA_CFLAGS += $(CFLAGS)

	obj-m := rnp.o
	rnp-objs :=   \
		rnp_main.o \
		rnp_common.o \
		rnp_debugfs.o \
		rnp_ethtool.o \
		rnp_lib.o \
		rnp_mbx.o \
		rnp_pcs.o \
		rnp_n10.o \
		rnp_n500.o \
		rnp_phy.o \
		rnp_mbx_fw.o\
		rnp_sriov.o \
		rnp_param.o \
		rnp_compat.o \
		rnp_sysfs.o \
		rnp_dcb.o \
		rnp_ptp.o \
		rnp_mpe.o 


else	# ifneq($(KERNELRELEASE),)
# normal makefile

DRIVER := rnp

ifeq (,$(wildcard .define.mk))
# $(error Cannot find define.mk, run do_build.sh first)
# in default we use this cflags 
	EXTRA_CFLAGS +=   -DN10 -DFIX_MAC_PADDIN -DFIX_VF_BUG   
  $(warning *** compile without define.mk.)
else
	-include $(PWD)/.define.mk
	EXTRA_CFLAGS +=   -DN10 -DFIX_MAC_PADDIN -DFIX_VF_BUG   
endif
	#EXTRA_CFLAGS += -Wno-unused-function -Wno-unused-variable -Wno-unused-label

ifeq (,$(wildcard common.mk))
  $(error Cannot find common.mk build rules)
else
  include common.mk
endif

# check for ft cpu
FT_FLAGS = $(shell lscpu | grep FT_200|wc -l)
ifneq ($(FT_FLAGS),0)
        EXTRA_CFLAGS += -DRNP_PKT_TIMEOUT=300 -DRNP_RX_PKT_POLL_BUDGET=128 -DRNP_PKT_TIMEOUT_TX=200 -DFT_PADDING
  $(warning *** compile ft cpu)
#else
#  $(warning *** compile not ft cpu)
endif

is_hexin = $(shell lscpu | grep ppc64le |wc -l)
ifneq ($(is_hexin),0)
    EXTRA_CFLAGS += -DRNP_MAX_RINGS=8
  	$(warning *** compile hexin cpu)
endif

FT_FLAGS = $(shell lscpu | grep 2500/|wc -l)
ifneq ($(FT_FLAGS),0)
        EXTRA_CFLAGS += -DRNP_PKT_TIMEOUT=300 -DRNP_RX_PKT_POLL_BUDGET=128 -DRNP_PKT_TIMEOUT_TX=200 -DFT_PADDING
  $(warning *** compile ft cpu)
#else
#  $(warning *** compile not ft cpu)
endif

# check for bridges
PCI_BRIDGE = $(shell lspci -n | grep 10b5:8748 -m 1 |wc -l)
ifneq ($(PCI_BRIDGE),0)
        EXTRA_CFLAGS += -DTSRN10_RX_DEFAULT_LINE=2 -DTSRN10_RX_DEFAULT_BURST=2
  $(warning *** reduce desc fetch since spec pci bridge)
#else
#  $(warning *** not detect spec pci bridge $(PCI_BRIDGE))
endif

PCI_BRIDGE = $(shell lspci -n | grep 10b5:8764 -m 1 |wc -l)
ifneq ($(PCI_BRIDGE),0)
        EXTRA_CFLAGS += -DTSRN10_RX_DEFAULT_LINE=2 -DTSRN10_RX_DEFAULT_BURST=2
  $(warning *** reduce desc fetch since spec pci bridge)
#else
#  $(warning *** not detect spec pci bridge $(PCI_BRIDGE))
endif

# Check that kernel version is at least 2.6.0, since we don't support 2.4.x
# kernels with the ixgbe driver. We can't use minimum_kver_check since SLES 10
# SP4's Make has a bug which causes $(eval) inside an ifeq conditional to error
# out. This was fixed in Make 3.81, but SLES 10 SP4 does not have a fix for
# this yet.
ifeq (0,$(shell [ ${KVER_CODE} -lt $(call get_kvercode,2,6,0) ]; echo "$?"))
  $(warning *** Aborting the build.)
  $(error This driver is not supported on kernel versions older than 2.6.0)
endif

######################
# Kernel Build Macro #
######################

# customized kernelbuild function
#
# ${1} is the kernel build target
# ${2} may contain extra rules to pass to kernelbuild macro
#
# We customize the kernelbuild target in order to provide our hack to disable
# CONFIG_PTP_1588_CLOCK support should -DNO_PTP_SUPPORT be defined in the extra
# cflags given on the command line.

devkernelbuild = $(call kernelbuild,$(if $(filter -DNO_PTP_SUPPORT,${EXTRA_CFLAGS}),CONFIG_PTP_1588_CLOCK=n) ${2},${1})

# Command to update initramfs or display a warning message
ifeq (${cmd_initrd},)
define cmd_initramfs
@echo "Unable to update initramfs. You may need to do this manually."
endef
else
define cmd_initramfs
@echo "Updating initramfs..."
-@$(call cmd_initrd)
endef
endif

###############
# Build rules #
###############

# Standard compilation, with regular output
default:
	@+$(call devkernelbuild,modules)

# Noisy output, for extra debugging
noisy:
	@+$(call devkernelbuild,modules,V=1)

# Silence any output generated
silent:
	@+$(call devkernelbuild,modules,>/dev/null)

# Enable higher warning level
checkwarnings: clean
	@+$(call devkernelbuild,modules,W=1)

# Run sparse static analyzer
sparse: clean
	@+$(call devkernelbuild,modules,C=2 CF="-D__CHECK_ENDIAN__ -Wbitwise -Wcontext")

# Run coccicheck static analyzer
ccc: clean
	@+$(call devkernelbuild,modules,coccicheck MODE=report))

# Build manfiles
manfile:
	@gzip -c ../${DRIVER}.${MANSECTION} > ${DRIVER}.${MANSECTION}.gz

# Clean the module subdirectories
clean:
	@+$(call devkernelbuild,clean)
	@-rm -rf *.${MANSECTION}.gz *.ko .define.mk
# make for anolis os
anolis:  EXTRA_CFLAGS += -DANOLIS_OS
anolis:
	@echo "Compile for anolis .."
	@echo "EXTRA_CFLAGS += -DKYLIN_OS " > $(PWD)/.define.mk
	@+$(call devkernelbuild,modules)

# make for kylin os
kylin:  EXTRA_CFLAGS += -DKYLIN_OS
kylin:
	@echo "Compile for kylin..."
	@echo "EXTRA_CFLAGS += -DKYLIN_OS " > $(PWD)/.define.mk
	@+$(call devkernelbuild,modules)

# make for ouler os
euler:  EXTRA_CFLAGS += -DEULER_OS
euler:
	@echo "Compile for euler..."
	@echo "EXTRA_CFLAGS += -DEULER_OS " > $(PWD)/.define.mk
	@+$(call devkernelbuild,modules)

# make for kylin os with smaller memory
kylin_sm:  EXTRA_CFLAGS += -DKYLIN_OS -DOPTM_WITH_LPAGE
kylin_sm:
	@echo "Compile for kylin with smaller memory..."
	@echo "EXTRA_CFLAGS += -DKYLIN_OS -DOPTM_WITH_LPAGE " > $(PWD)/.define.mk
	@+$(call devkernelbuild,modules)

disable_split: EXTRA_CFLAGS += -DDISABLE_PACKET_SPLIT
disable_split:
	@echo "Compile with disable_split..."
	@echo "EXTRA_CFLAGS += -DDISABLE_PACKET_SPLIT " > $(PWD)/.define.mk
	@+$(call devkernelbuild,modules)

no_mbx: EXTRA_CFLAGS += -DNO_CM3_MBX
no_mbx:
	@echo "Compile with no mbx..."
	@echo "EXTRA_CFLAGS += -DNO_CM3_MBX " > $(PWD)/.define.mk
	@+$(call devkernelbuild,modules)

# Install the modules and manpage
mandocs_install: manfile
	@echo "Copying manpages..."
	@install -D -m 644 ${DRIVER}.${MANSECTION}.gz ${INSTALL_MOD_PATH}${MANDIR}/man${MANSECTION}/${DRIVER}.${MANSECTION}.gz

# Install kernel module files. This target is called by the RPM specfile
# when generating binary RPMs, and is not expected to modify files outside
# of the build root. Thus, it must not update initramfs, or run depmod.
modules_install: default
	@echo "Installing modules..."
	@install -D -m 644 ../pci.updates /usr/share/hwdata/pci.ids.d/mucse.ids 
	@+$(call devkernelbuild,modules_install)

# After installing all the files, perform necessary work to ensure the
# system will use the new modules. This includes running depmod to update
# module dependencies and updating the initramfs image in case the module is
# loaded during early boot.
install: modules_install mandocs_install
	@echo "Running depmod..."
	$(call cmd_depmod)
	$(call cmd_initramfs)

mandocs_uninstall:
	if [ -e ${INSTALL_MOD_PATH}${MANDIR}/man${MANSECTION}/${DRIVER}.${MANSECTION}.gz ] ; then \
		rm -f ${INSTALL_MOD_PATH}${MANDIR}/man${MANSECTION}/${DRIVER}.${MANSECTION}.gz ; \
	fi;

# Remove installed module files. This target is called by the RPM specfile
# when generating binary RPMs, and is not expected to modify files outside
# of the build root. Thus, it must not update the initramfs image or run
# depmod.
modules_uninstall:
	rm -f ${INSTALL_MOD_PATH}/lib/modules/${KVER}/${INSTALL_MOD_DIR}/${DRIVER}.ko;

# After uninstalling all the files, perform necessary work to restore the
# system back to using the default kernel modules. This includes running
# depmod to update module dependencies and updating the initramfs image.
uninstall:
	rm -f ${INSTALL_MOD_PATH}/lib/modules/${KVER}/${INSTALL_MOD_DIR}/${DRIVER}.ko;
	$(call cmd_depmod)
	$(call cmd_initramfs)

########
# Help #
########
help:
	@echo 'Build targets:'
	@echo '  default             - Build module(s) with standard verbosity'
	@echo '  noisy               - Build module(s) with V=1 verbosity -- very noisy'
	@echo '  silent              - Build module(s), squelching all output'
	@echo ''
	@echo 'Static Analysis:'
	@echo '  checkwarnings       - Clean, then build module(s) with W=1 warnings enabled'
	@echo '  sparse              - Clean, then check module(s) using sparse'
	@echo '  ccc                 - Clean, then check module(s) using coccicheck'
	@echo ''
	@echo 'Cleaning targets:'
	@echo '  clean               - Clean files generated by kernel module build'
	@echo ''
	@echo 'Other targets:'
	@echo '  manfile             - Generate a gzipped manpage'
	@echo '  modules_install     - Install the module(s) only'
	@echo '  mandocs_install     - Install the manpage only'
	@echo '  install             - Build then install the module(s) and manpage, and update initramfs'
	@echo '  modules_uninstall   - Uninstall the module(s) only'
	@echo '  mandocs_uninstall   - Uninstall the manpage only'
	@echo '  uninstall           - Uninstall the module(s) and manpage, and update initramfs'
	@echo '  help                - Display this help message'
	@echo ''
	@echo 'Variables:'
	@echo '  LINUX_VERSION       - Debug tool to force kernel LINUX_VERSION_CODE. Use at your own risk.'
	@echo '  W=N                 - Kernel variable for setting warning levels'
	@echo '  V=N                 - Kernel variable for setting output verbosity'
	@echo '  INSTALL_MOD_PATH    - Add prefix for the module and manpage installation path'
	@echo '  INSTALL_MOD_DIR     - Use module directory other than updates/drivers/net/ethernet/intel/${DRIVER}'
	@echo ' Other variables may be available for tuning make process, see'
	@echo ' Kernel Kbuild documentation for more information'

.PHONY: default noisy clean manfile silent sparse ccc install uninstall help

endif	# ifneq($(KERNELRELEASE),)
