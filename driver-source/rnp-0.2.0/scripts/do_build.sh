#!/bin/bash

cwd=$(dirname $(readlink -f $0))
cd $cwd

CFLAGS=""
NIC_OFF=0x100000
QUEUES_PEER_FUN=8
FPGA=1
PV=1



modprobe ptp
modprobe vxlan

#FT_2000_FLAGS=" -DRNP_PKT_TIMEOUT=300 -DRNP_RX_PKT_POLL_BUDGET=128 -DRNP_PKT_TIMEOUT_TX=200  -DFT_PADDING"
FT_FLAGS=" -DRNP_PKT_TIMEOUT=300 -DRNP_RX_PKT_POLL_BUDGET=128 -DRNP_PKT_TIMEOUT_TX=200 -DFT_PADDING "

BRIDGE_FLAGS=" -DTSRN10_RX_DEFAULT_LINE=2 -DTSRN10_RX_DEFAULT_BURST=2 "


Usage=" $0  [help] [hi_dma]  \n \
    [rx-debug] [tx-debug] [hw_debug] [debug] [skbdump] [io] \n \
    [pv=xx] [offloading]   \n \
    [poll] [no-tx-irq] [no-rx-irq] [irq-debug] \n \
    [queue=N] [nic=0xN]  \n \
    [no-pf0] [no-pf1] [2pf] [bar4]\
    [other-args] [no-pf1] [no-dma2] \n \
    [mbox] [iov] [vf-debug] \n\
    <target> \n \


target: \n\tuv440-2pf | uv440 | n10 |n10mbx | n10mbx_vf_fix"

is_ft_2000=$(lscpu |grep FT-200 |wc -l)
if [ ${is_ft_2000} -gt 0 ];then
    CFLAGS+=${FT_FLAGS}
fi
is_ft_2500=$(lscpu |grep 2500 |wc -l)
if [ ${is_ft_2500} -gt 0 ];then
    CFLAGS+=${FT_FLAGS}
fi

is_hexin=$(lscpu |grep POWER8 |wc -l)
if [ ${is_hexin} -gt 0 ];then
    CFLAGS+=" -DRNP_MAX_RINGS=16 "
fi

is_euler=$(cat /etc/os-release |grep openEuler | wc -l)
if [ ${is_euler} -gt 0 ];then
    CFLAGS+=" -DEULER_OS "

fi

#check bridges
bridges=("10b5:8748" "10b5:8764")
for bridge in ${bridges[@]}
do
        is_bridges=$(lspci -n | grep $bridge -m 1 |wc -l)
        if [ ${is_bridges} -gt 0 ];then
                CFLAGS+=${BRIDGE_FLAGS}
                break
        fi
done	



for arg in "$@"
do
    shift
    [[ $arg == *help ]]              && echo -e "$Usage"                               && exit 0
    [[ $arg == -h ]]                 && echo "$Usage"                                  && exit 0
    [[ $arg == queue* ]]             && IN_QUEUES_PEER_FUN=${arg//queue=/}                && continue
    [[ $arg == ksrc* ]]             && KSRC=${arg//ksrc=/}                && continue
    [[ $arg == nic* ]]               && NIC_OFF=${arg//nic=/}                          && continue
    [[ $arg == asic ]]               && FPGA=0                                          && continue
    [[ $arg == pv ]]                 && PV=${arg//pv=/ }                  && continue

    # remove debug/io/no-tx-irq args
    [[ $arg == irq-debug ]]          && CFLAGS+=" -DIRQ_DEBUG=1 "                            && continue
    [[ $arg == debug ]]              && CFLAGS+=" -DDEBUG=1 "                            && continue
    [[ $arg == hw-debug ]]           && CFLAGS+=" -DHW_DEBUG=1 "                            && continue
    [[ $arg == io ]]                 && CFLAGS+=" -DIO_PRINT=1 "                         && continue
    [[ $arg == no-tx-irq ]]          && CFLAGS+=" -DDISABLE_TX_IRQ=1 "                   && continue
    [[ $arg == no-rx-irq ]]          && CFLAGS+=" -DDISABLE_RX_IRQ=1 "                   && continue
    [[ $arg == poll* ]]              && CFLAGS+=" -DDISABLE_TX_IRQ=1 -DDISABLE_RX_IRQ=1  " && continue
    [[ $arg == skbdump ]]            && CFLAGS+=" -DSKB_DUMP=1  "                        && continue
    [[ $arg == hi_dma ]]             && CFLAGS+=" -DENABLE_64BIT_DMA  "                       && continue
    [[ $arg == offload* ]]           && CFLAGS+=" -DHW_OFFLOADING  "                      && continue
    [[ $arg == tx-debug* ]]          && CFLAGS+=" -DCONFIG_RNP_TX_DEBUG=1  "                        && continue
    [[ $arg == rx-debug* ]]          && CFLAGS+=" -DCONFIG_RNP_RX_DEBUG=1  "                        && continue
    [[ $arg == vf-debug* ]]          && CFLAGS+=" -DCONFIG_RNP_VF_DEBUG=1  "                        && continue
    [[ $arg == no-pf1 ]]             && CFLAGS+=" -DCONFIG_RNP_DISABLE_PF1=1  "                        && continue
    [[ $arg == no-dma2 ]]             && CFLAGS+=" -DCONFIG_RNP_DISABLE_DMA2=1  "                        && continue
    [[ $arg == no-dma1 ]]             && CFLAGS+=" -DCONFIG_RNP_DISABLE_DMA1=1  "                        && continue
    [[ $arg == feiteng ]]             && CFLAGS+=" -DFEITENG  "                        && continue
    [[ $arg == no-pf0 ]]             && CFLAGS+=" -DCONFIG_RNP_DISABLE_PF0=1  "                        && continue
    [[ $arg == 2pf ]]         && CFLAGS+=" -DHAS_2PF  "                        && continue
    [[ $arg == vf ]]         && CFLAGS+=" -DENABLE_VF  "                        && continue
    [[ $arg == mbox ]]      && CFLAGS+=" -DCONFIG_RNP_MBX=1  "                        && continue
    [[ $arg == iov ]]      && CFLAGS+=" -DCONFIG_RNP_IOV=1  "                        && continue
    [[ $arg == simulate_tx ]]      && CFLAGS+=" -DSIMULATE_TX  "                        && continue
    [[ $arg == vebug ]]      && CFLAGS+=" -DRNP_IOV_VEB_BUG_NOT_FIXED=1  "                        && continue
    [[ $arg == fix_mac ]]      && CFLAGS+=" -DFIX_MAC_TEST=1  "                        && continue
    [[ $arg == fix_veb_bug ]]      && CFLAGS+=" -DFIX_VEB_BUG=1  "                        && continue
    [[ $arg == nic_vf_fixed ]]      && CFLAGS+=" -DNIC_VF_FXIED=1  "                        && continue
    [[ $arg == msg_probe ]]      && CFLAGS+=" -DMSG_PROBE_ENABLE=1  "                        && continue
    [[ $arg == msg_ifup ]]      && CFLAGS+=" -DMSG_IFUP_ENABLE=1  "                        && continue
    [[ $arg == msg_ifdown ]]      && CFLAGS+=" -DMSG_IFDOWN_ENABLE=1  "                        && continue
    [[ $arg == kylin_os ]]      && CFLAGS+=" -DKYLIN_OS=1  "                        && continue
    [[ $arg == dcb ]]		     && FEATURE[${#FEATURE[*]}]=RNP_DCB_SUPPORT=y && continue

    # save other-arg
    set -- "$@" "$arg"
done
set -- "$@"
TARGET=${1:-n10mbx_vf_fix}
shift
ARGS="$@"

[[ $TARGET == uv440-2pf ]]     && NIC_OFF=0x0      && QUEUES_PEER_FUN=8 && FPGA=1 && CFLAGS+=" -DUV440_2PF -DNIC_BAR4 -DHAS_2PF -DISOLATION_DMA=1 -DRNP_MAX_VF_CNT=4 -DNO_MBX_VERSION -DNIC_VF_FXIED -DNO_MBX_VERSION"
[[ $TARGET == uv440 ]] && NIC_OFF=0x0    && QUEUES_PEER_FUN=8 && FPGA=1 && CFLAGS+=" -DUV440_2PF -DNIC_BAR4 -DHAS_2PF -DISOLATION_DMA=1 -DRNP_MAX_VF_CNT=64 -DNO_MBX_VERSION"
[[ $TARGET == n10 ]]     && NIC_OFF=0x0      && QUEUES_PEER_FUN=8 && FPGA=1 && CFLAGS+=" -DNO_MBX_VERSION -DN10 -DNIC_BAR4 -DHAS_2PF -DISOLATION_DMA=1 -DRNP_MAX_VF_CNT=64"
[[ $TARGET == n20 ]]     && NIC_OFF=0x0      && QUEUES_PEER_FUN=8 && FPGA=1 && CFLAGS+=" -DNO_MBX_VERSION -DN20 -DNIC_BAR4 -DHAS_2PF -DISOLATION_DMA=1 -DRNP_MAX_VF_CNT=64"
[[ $TARGET == n500 ]]     && NIC_OFF=0x0      &&   CFLAGS+="-DN500"
[[ $TARGET == n10mbx_vf_fix ]]     && NIC_OFF=0x0      &&   CFLAGS+="-DN10 -DFIX_MAC_PADDIN -DFIX_VF_BUG"
[[ $TARGET == n10mbx ]]     && NIC_OFF=0x0      &&   CFLAGS+="-DN10 -DRNP_MAX_VF_CNT=64"

if [[ -z "$IN_QUEUES_PEER_FUN" ]];then
IN_QUEUES_PEER_FUN=$QUEUES_PEER_FUN
fi


buildargs="$CMDLINE $ARGS $CFLAGS  "
#if [ $FPGA -ne "0" ];then
#    buildargs+=" -DCONFIG_RNP_FPGA " 
#fi
echo "build: $TARGET, $buildargs "

install -D -m 644 ../pci.updates /usr/share/hwdata/pci.ids.d/mucse.ids 2>/dev/null

make -C ../src clean
echo "EXTRA_CFLAGS += $buildargs " > ../src/.define.mk

if [[ -z $KSRC ]];then
	echo "use default ksrc"
else
	echo "KSRC=$KSRC" >> ../src/.define.mk
fi
export SWD=$cwd
make -C ../src ${FEATURE[@]} -j3
