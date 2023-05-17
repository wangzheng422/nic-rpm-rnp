#!/usr/bin/env python3
import argparse
import sys
import binascii
import re
import fcntl
import struct
import os
import socket
import threading
import sys
from random import randint

from tuntap import TunTap
try:
    from pudb import set_trace
except:
    from pdb import set_trace

TUNSETIFF = 0x400454ca
TUNSETOWNER = TUNSETIFF + 2
IFF_TUN = 0x0001
IFF_TAP = 0x0002
IFF_NO_PI = 0x1000

import fcntl,struct,socket
from scapy.all import IP,TCP,UDP,conf,send,Raw,sendp,Ether,Dot1Q

#open dev
tun0 = TunTap(nic_type="Tap",nic_name="tap0")
#tun0= TunTap(nic_type="Tun", nic_name="tun0")


def vlan_reply():
    ##=== create udp packet
    udp_payload=b"hello"
    ether   = Ether(dst="20:04:0f:0a:c5:c3",src="f0:1e:34:13:43:13")
    vlan    = Dot1Q(vlan=3)
    ip      = IP(src="192.2.3.4",dst="192.2.3.9")
    udp     = UDP(sport=168,dport=168,chksum=0x1234)
    payload = Raw(load=udp_payload)
    packet  = ether / vlan / ip / udp / payload 

    while True:
        print(binascii.hexlify(bytes(packet)))

        tun0.write(bytes(packet))
        input("any key to continue..")

def udp_reply():
    ##=== create udp packet
    udp_payload=b"hello"
    ether   = Ether(dst="20:04:0f:0a:c5:c3",src="f0:1e:34:13:43:13")
    ip      = IP(src="192.2.3.4",dst="192.2.3.9")
    udp     = UDP(sport=168,dport=168,chksum=0x1234)
    payload = Raw(load=udp_payload)
    packet  = ether / ip / udp / payload 

    while True:
        print(binascii.hexlify(bytes(packet)))

        tun0.write(bytes(packet))
        input("any key to continue..")


def pcap_reply(pacfile):
    pkts=rdpcap(pacfile)
    for pkt in pkts:
        tun0.write(bytes(packet))
        input("any key to continue..")

if __name__ == '__main__':
    udp_reply()
    #vlan_reply()
