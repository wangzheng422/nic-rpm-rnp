#!/bin/sh

vf=eth


VLAN=1
vf0_id=3
vf_dev_pref=eth
for id in $(seq 0 62)
do
    vf_dev="$vf_dev_pref$(( $vf0_id))"


    vlan_dev="${vf_dev}.${VLAN}"
    vlan_ip="104.1.${VLAN}.1"
    vf_ip="101.1.${VLAN}.1"

    echo "$vf_dev, $VLAN, $vlan_dev, $vlan_ip, $vf_ip"

    ip link add link $vf_dev name $vlan_dev type vlan id $VLAN
    nmcli dev set $vf_dev managed no
    nmcli dev set $vlan_dev managed no
    ifconfig $vlan_dev $vlan_ip netmask 255.255.255.0 up
    ifconfig $vf_dev $vf_ip netmask 255.255.255.0 up

    vf0_id=$(($vf0_id + 1))
    VLAN=$(($VLAN + 1))

done
