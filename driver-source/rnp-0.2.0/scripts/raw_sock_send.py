#!/usr/bin/env python3
import sys,fcntl
from scapy.all import *
import socket
from optparse import OptionParser

load_contrib("mpls")


ETH_P_ALL = 3


def get_mac_addr(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    info = fcntl.ioctl(s.fileno(), 0x8927,  struct.pack('256s', bytes(ifname[:15], 'utf-8')))
    return ''.join(['%02x:' % b for b in info[18:24]])[:-1]

if __name__ == "__main__":
    parser = OptionParser(usage="usage: %prog ")
    parser.add_option("-a", "--arp", action="store_true",
                      dest="arp_req", help="arp req", default=False)

    parser.add_option("-A", "--areply", action="store_true",
                      dest="arp_reply", help="arp_reply", default=False)
    parser.add_option("-u", "--udp", action="store_true",
                      dest="udp", help="udp", default=False)
    parser.add_option("-m", "--mpls", action="store_true",
                      dest="mpls", help="mpls", default=False)
    parser.add_option("-t", "--tcp", action="store_true",
                      dest="tcp", help="tcp", default=False)
    parser.add_option("-v", "--vid", action="store",
                      dest="vlan_id", help="vlan id", default=1)
    parser.add_option("", "--my_ip", action="store",
                      dest="my_ip", help="my ip", default="4.4.4.4")
    parser.add_option("", "--dst_ip", action="store",
                      dest="dst_ip", help="dst ip", default="5.5.5.5")
    parser.add_option("", "--dst_mac", action="store",
                      dest="dst_mac", help="dst_mac", default="62:63:64:65:66:67")
    parser.add_option("", "--dport", action="store",
                      dest="dport", help="dst port", default=5238)
    parser.add_option("", "--sport", action="store",
                      dest="sport", help="dst port", default=6238)
    parser.add_option("-i", "--if", action="store",
                      dest="interface", help="interface", default="eth1")
    (options, args) = parser.parse_args()
    pkt = None

    my_ip=options.my_ip
    borad_mac="ff:ff:ff:ff:ff:ff"
    dst_mac=options.dst_mac
    dst_ip=options.dst_ip
    interface = options.interface
    vlan_id = int(options.vlan_id)
    dst_port = int(options.dport)
    s_port = int(options.sport)

    s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(ETH_P_ALL))
    s.bind((interface, 0))

    my_mac = get_mac_addr(interface)
    print(my_mac)


    if options.arp_req:
        arp_req = ARP(op="who-has",psrc=my_ip, pdst=dst_ip,hwsrc=my_mac,hwdst=borad_mac)
        if vlan_id != 1:
            pkt=Ether(dst=borad_mac,src=my_mac)/Dot1Q(vlan=vlan_id)/arp_req
        else:
            pkt=Ether(dst=borad_mac,src=my_mac)/arp_req
    if options.arp_reply:
        arp_reply = ARP(op=2,pdst=dst_ip,psrc=my_ip, hwsrc=my_mac, hwdst=dst_mac)
        if vlan_id != 1:
            pkt=Ether(dst=dst_mac,src=my_mac)/Dot1Q(vlan=vlan_id)/arp_reply
        else:
            pkt=Ether(dst=dst_mac,src=my_mac)/arp_reply

    if options.tcp:
        tcp = TCP(flags="S", sport=s_port,dport=dst_port)/Raw("Hallo world!")
        if vlan_id != 1:
            pkt=Ether(dst=dst_mac,src=my_mac)/Dot1Q(vlan=vlan_id)/IP(dst=dst_ip,src=my_ip)/tcp
        else:
            pkt=Ether(dst=dst_mac,src=my_mac)/IP(dst=dst_ip,src=my_ip)/tcp

    if options.mpls:
            pkt=Ether(dst=dst_mac,src=my_mac)/MPLS(label=255)/IP(src=my_ip,dst=dst_ip)

    if options.udp:
        udp = UDP(sport=s_port,dport=dst_port)/Raw("Hallo world!")
        if vlan_id != 1:
            pkt=Ether(dst=dst_mac,src=my_mac)/Dot1Q(vlan=vlan_id)/IP(dst=dst_ip,src=my_ip)/udp
        else:
            pkt=Ether(dst=dst_mac,src=my_mac,type=0x0800)/IP(dst=dst_ip,src=my_ip)/udp

    if pkt != None:
        pkt.show()
        hexdump(pkt)

        raw_pkt = raw(pkt)
        print(s.send(raw_pkt))

