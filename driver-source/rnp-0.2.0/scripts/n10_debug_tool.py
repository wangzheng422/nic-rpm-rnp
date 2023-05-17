#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from random import seed
from random import randint
import os
import sys
import mmap
import struct
from optparse import OptionParser

try:
    from pudb import set_trace
except:
    from pdb import set_trace

"""
This is designed primarily for use with accessing /dev/mem on OMAP platforms.
It should work on other platforms and work to mmap() files rather then just
/dev/mem, but these use cases aren't well tested.
All file accesses are aligned to DevMem.word bytes, which is 4 bytes on ARM
platforms to avoid data abort faults when accessing peripheral registers.
References:
    http://wiki.python.org/moin/PythonSpeed/PerformanceTips
    http://www.python.org/dev/peps/pep-0008/
"""

g_debug=False
VF_EN=True
devm_debug = 0
#devm_debug = 1

class DevMemBuffer:
    """This class holds data for objects returned from DevMem class. It allows an easy way to print hex data"""

    def __init__(self, base_addr, data):
        self.data = data
        self.base_addr = base_addr

    def __len__(self):
        return len(self.data)

    def __getitem__(self, key):
        return self.data[key]

    def __setitem__(self, key, value):
        self.data[key] = value

    def hexdump(self, word_size = 4, words_per_row = 4):
        # Build a list of strings and then join them in the last step.
        # This is more efficient then concat'ing immutable strings.

        d = self.data
        dump = []

        word = 0
        while (word < len(d)):
            dump.append('0x{0:02x}:  '.format(self.base_addr
                                              + word_size * word))

            max_col = word + words_per_row
            if max_col > len(d): max_col = len(d)

            while word < max_col:
                # If the word is 4 bytes, then handle it and continue the
                # loop, this should be the normal case
                if word_size == 4:
                    dump.append(" {0:08x} ".format(d[word]))

                # Otherwise the word_size is not an int, pack it so it can be
                # un-packed to the desired word size.  This should blindly
                # handle endian problems (Verify?)
                elif word_size == 2:
                    for halfword in struct.unpack('HH', struct.pack('I',(d[word]))):
                        dump.append(" {0:04x}".format(halfword))

                elif word_size == 1:
                    for byte in struct.unpack('BBBB', struct.pack('I',(d[word]))):
                        dump.append(" {0:02x}".format(byte))

                word += 1

            dump.append('\n')

        # Chop off the last new line character and join the list of strings
        # in to a single string
        return ''.join(dump[:-1])

    def __str__(self):
        return self.hexdump()


class DevMem:
    """Class to read and write data aligned to word boundaries of /dev/mem"""

    # Size of a word that will be used for reading/writing
    word = 4
    mask = ~(word - 1)
    f = None

    def __init__(self, base_addr, length = 1, filename = '/dev/mem',
                 debug = 0):

        if base_addr < 0 or length < 0: raise AssertionError
        self._debug = debug

        self.base_addr = (int)(base_addr & ~(mmap.PAGESIZE - 1))
        self.base_addr_offset = base_addr - self.base_addr

        stop = base_addr + length * self.word
        if (stop % self.mask):
            stop = (stop + self.word) & ~(self.word - 1)

        stop = int(stop)

        self.length = int(stop - self.base_addr)
        self.fname = filename

        # Check filesize (doesn't work with /dev/mem)
        #filesize = os.stat(self.fname).st_size
        #if (self.base_addr + self.length) > filesize:
        #    self.length = filesize - self.base_addr

        self.debug('init with base_addr = {0} and length = {1} on {2}'.
                format(hex(self.base_addr), hex(self.length), self.fname))

        # Open file and mmap
        self.f = os.open(self.fname, os.O_RDWR | os.O_SYNC)
        self.mem = mmap.mmap(self.f, self.length, mmap.MAP_SHARED,
                mmap.PROT_READ | mmap.PROT_WRITE,
                offset=self.base_addr)

    def __del__(self):
        if self.f:
            self.mem.close()
            os.close(self.f)

    def read(self, offset, length):
        """Read length number of words from offset"""

        if offset < 0 or length < 0: raise AssertionError

        # Make reading easier (and faster... won't resolve dot in loops)
        mem = self.mem

        self.debug('reading {0} bytes from offset {1}'.
                   format(length * self.word, hex(offset)))

        # Compensate for the base_address not being what the user requested
        # and then seek to the aligned offset.
        virt_base_addr = self.base_addr_offset & self.mask
        mem.seek(virt_base_addr + offset)

        # Read length words of size self.word and return it
        data = []
        for i in range(length):
            data.append(struct.unpack('I', mem.read(self.word))[0])

        abs_addr = self.base_addr + virt_base_addr
        return DevMemBuffer(abs_addr + offset, data)


    def write(self, offset, din):
        """Write length number of words to offset"""

        if offset < 0 or len(din) <= 0: raise AssertionError

        self.debug('writing {0} bytes to offset {1}'.
                format(len(din) * self.word, hex(offset)))

        # Make reading easier (and faster... won't resolve dot in loops)
        mem = self.mem

        # Compensate for the base_address not being what the user requested
        # fix double plus offset
        #offset += self.base_addr_offset

        # Check that the operation is going write to an aligned location
        if (offset & ~self.mask): raise AssertionError

        # Seek to the aligned offset
        virt_base_addr = self.base_addr_offset & self.mask
        mem.seek(virt_base_addr + offset)

        # Read until the end of our aligned address
        for i in range(len(din)):
            self.debug('writing at position = 0x{0:x}: 0x{1:x}'.
                        format(self.mem.tell(), din[i]))
            # Write one word at a time
            mem.write(struct.pack('I', din[i]))

    def debug_set(self, value):
        self._debug = value

    def debug(self, debug_str):
        if self._debug: print('DevMem Debug: {0}'.format(debug_str))


PCIE_PHY0_REG = 0x007c0000
PCIE_PHY1_REG = 0x007e0000
PCIE_CFG_REG = 0x00700000

VR_XS_PMA_SNPS_CR_CTRL = (0x18000 + (0xa0))
VR_XS_PMA_SNPS_CR_ADDR = (0x18000 + (0xa1))
VR_XS_PMA_SNPS_CR_DATA = (0x18000 + (0xa2))





def devmem_open(path, name):
    fname = path + "/" + name
    fsize = 0
    try:
        fsize = os.stat(fname).st_size
    except:
        return None

    devmem = DevMem(0, int(fsize/DevMem.word), fname, devm_debug)
    return devmem


class pcidev:

    dev = {}

    def __init__(self, vender=0x8848, device=0x1000, nr=0, pci_slot=""):
        self.vender = vender
        self.device = device
        self.nr = nr
        self.pci_slot=pci_slot
        cnt = self.probe()
        if cnt == 0:
            print("canot find pci dev")
            exit(-1)

    def add_device(self, path):
        print("enable device:", path)
        os.system("echo 1 > {0}/enable 2>/dev/null".format(path))

        self.dev["bar0"] = devmem_open(path, "resource0")
        self.dev["bar2"] = devmem_open(path, "resource2")
        self.dev["bar4"] = devmem_open(path, "resource4")

    def probe(self):
        cnt = 0
        for pdev in os.listdir("/sys/bus/pci/devices"):
            found = False
            vender_str = os.popen(
                "cat  /sys/bus/pci/devices/{0}/vendor".format(pdev)).readline()

            if self.pci_slot in pdev:
                device_str = os.popen(
                    "cat  /sys/bus/pci/devices/{0}/device".format(pdev)).readline()
                self.device = int(device_str, 16)
                self.add_device("/sys/bus/pci/devices/"+pdev)
                return 1
            if int(vender_str, 16) == self.vender:
                device_str = os.popen(
                    "cat  /sys/bus/pci/devices/{0}/device".format(pdev)).readline()
                if (self.device != 0 and int(device_str, 16) == self.device) or self.device == 0:
                    # found device
                    if self.device == 0:
                        self.device = int(device_str, 16)
                    if (self.nr == cnt) and len(self.pci_slot) == 0:
                        self.add_device("/sys/bus/pci/devices/"+pdev)
                        return 1
                    cnt += 1
        return len(self.dev)

    def cfg_read8(self, reg):
        shift = 8*(reg & 3)
        mask = (0xff << shift)
        v = self.cfg_read32(reg)
        return (v & mask) >> shift

    def cfg_read16(self, reg):
        shift = 8*(reg & 2)
        mask = (0xffff << shift)
        v = self.cfg_read32(reg)
        return (v & mask) >> shift

    def cfg_read32(self, reg):
        reg &= ~3
        #v = self.dev["cfg"].read(reg,4/DevMem.word)[0]
        return self.bar_read32(0, PCIE_CFG_REG + reg)

    def cfg_write8(self, reg, v):
        addr = reg & ~0x3
        rv = self.cfg_read32(reg)
        shift = 8*(reg & 3)
        mask = (0xff << shift)
        rv &= ~mask
        rv |= (v << shift)
        self.cfg_write32(reg, rv)

    def cfg_write16(self, reg, v):
        addr = reg & ~0x2
        rv = self.cfg_read32(reg)
        if reg & 0x2:
            rv &= (0x0000FFFF)
            rv |= v << 16
        else:
            rv &= 0xffff0000
            rv |= v
        self.cfg_write32(reg, rv)

    def cfg_write32(self, reg, v):
        #self.dev["cfg"].write(reg & ~0x3, [v])
        return self.bar_write32(0, PCIE_CFG_REG + reg, v)

    def bar_read32(self, bar, reg):
        bar = "bar{0}".format(bar)
        if self.dev[bar] == None:
            print("bar_read32: {} {}: bar is null".format(bar, reg))
            return 0xffffffff
        v = self.dev[bar].read(reg, int(4/DevMem.word))[0]
        return v

    def bar_write32(self, bar, reg, val):
        bar = "bar{0}".format(bar)
        if self.dev[bar] == None:
            print("bar_write32: {} {} {}: bar is null".format(bar, reg, val))
            return -1
        self.dev[bar].write(reg, [val])
        return 0


#=== phy reg access by cr
VR_XS_PMA_SNPS_CR_CTRL = (0x18000 + (0xa0))
VR_XS_PMA_SNPS_CR_ADDR = (0x18000 + (0xa1))
VR_XS_PMA_SNPS_CR_DATA = (0x18000 + (0xa2))

class n10():
    n10_pf = None
    NET_PHY_SUBSYSTEM = 0x0
    PCI_PHY_SUBSYSTEM = 0x1
    CTR_SUBSYSTEM = 0x2

    phy_addr_base = 0

    pcs_phy_regs =[
        0x00040000, 0x00041000, 0x00042000, 0x00043000,
        0x00040000, 0x00041000, 0x00042000, 0x00043000,
    ]

    lane = 0
    bar_off = 0

    def __init__(self, vender, device, nr, lane=0,pci_slot=""):
        if len(pci_slot) >0 and pci_slot.endswith(".1"):
            nr = 1
        if g_debug:
            print("vender:{} device:{} nr:{}".format(hex(vender), hex(device), nr))
        self.n10_pf = pcidev(vender, device, nr, pci_slot)
        if nr == 0:
            self.phy_addr_base = PCIE_PHY0_REG
        else:
            self.phy_addr_base = PCIE_PHY1_REG
            if VF_EN:
                self.bar_off = 1*1024*1024
                self.pcs_phy_regs[0] += self.bar_off;
                self.pcs_phy_regs[1] += self.bar_off;
                self.pcs_phy_regs[2] += self.bar_off;
                self.pcs_phy_regs[3] += self.bar_off;
        self.lane = lane

    def connect(self):
        pass

    def disconnect(self):
        pass

    def bar_ioread32(self, bar, addr,cnt=1):
        off = 0
        if bar == 4:
            off = self.bar_off
        v=[]
        while cnt>0:
            v.append([addr,self.n10_pf.bar_read32(bar,addr+off)])
            addr+=4
            cnt-=1
        return v

    def bar_iowrite32(self, bar, addr,v):
        off = 0
        if bar == 4:
            off = self.bar_off
        # set_trace()
        self.n10_pf.bar_write32(bar,addr+off,v)

    def pcs_ioread32(self, pcs_base_regs, pcs_reg):
        reg_hi = pcs_reg >> 8
        reg_lo = (pcs_reg & 0xff) << 2

        self.n10_pf.bar_write32(4,pcs_base_regs + (0xff << 2), reg_hi) # 0x3fc
        return self.n10_pf.bar_read32(4, pcs_base_regs + reg_lo)

    def pcs_iowrite32(self, pcs_base_regs, pcs_reg, value):
        reg_hi = pcs_reg >> 8
        reg_lo = (pcs_reg & 0xff) << 2

        self.n10_pf.bar_write32( 4, pcs_base_regs + (0xff << 2), reg_hi)  # 0x3fc
        self.n10_pf.bar_write32(4, pcs_base_regs + reg_lo, value)       # off
    
    def pcs_lane_ioread32(self, lane, pcs_reg):
        return self.pcs_ioread32(self.pcs_phy_regs[lane], pcs_reg)

    def pcs_lane_iowrite32(self, lane, pcs_reg, v):
        return self.pcs_iowrite32(self.pcs_phy_regs[lane], pcs_reg,v)

    def pcs_phy_cr_reg_write(self, pcs_lane_reg, phy_addr, data):
        # wait busy = 0
        while True:
            _v = self.pcs_ioread32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_CTRL)
            if (_v & (1 << 0)) == 0:
                break

        self.pcs_iowrite32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_ADDR, phy_addr)
        self.pcs_iowrite32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_DATA, data)

        v = self.pcs_ioread32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_CTRL)
        self.pcs_iowrite32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_CTRL, v | (1 << 1))

        v = self.pcs_ioread32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_CTRL)
        self.pcs_iowrite32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_CTRL, v | (1 << 0))

        # wait busy [0] = 0
        while True:
            _v = self.pcs_ioread32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_CTRL)
            if (_v & (1 << 0)) == 0:
                break
        return 0

    def pcs_phy_ioread16(self, lane, phy_addr):
        return self.pcs_phy_cr_reg_read(self.pcs_phy_regs[lane], phy_addr)

    def pcs_phy_iowrite16(self, lane, phy_addr,v):
        return self.pcs_phy_cr_reg_write(self.pcs_phy_regs[lane], phy_addr, v)

    def pcs_phy_cr_reg_read(self, pcs_lane_reg, phy_addr):
        # wait busy = 0
        while True:
            _v = self.pcs_ioread32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_CTRL)
            if (_v & (1 << 0)) == 0:
                break

        self.pcs_iowrite32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_ADDR, phy_addr)

        v = self.pcs_ioread32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_CTRL)
        self.pcs_iowrite32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_CTRL, v & 1)

        v = self.pcs_ioread32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_CTRL)
        self.pcs_iowrite32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_CTRL, v | (1 << 0))

        # wait busy [0] = 0
        while True:
            _v = self.pcs_ioread32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_CTRL)
            if (_v & (1 << 0)) == 0:
                break
        return self.pcs_ioread32(pcs_lane_reg, VR_XS_PMA_SNPS_CR_DATA)

    def pcs_phy_read16(self, phy_reg):
        addr = self.phy_addr_base + ((phy_reg >> 1) << 2)
        v = self.n10_pf.bar_read32(0, addr)
        if phy_reg & 0x1:
            return (v >> 16) & 0xffff
        else:
            return v & 0xffff

    def pci_phy_read16(self, phy_reg):
        addr = self.phy_addr_base + ((phy_reg >> 1) << 2)
        v = self.n10_pf.bar_read32(0, addr)
        if phy_reg & 0x1:
            return (v >> 16) & 0xffff
        else:
            return v & 0xffff

    def pci_phy_write16(self, phy_reg, data):
        data = data & 0xffff

        addr = self.phy_addr_base + ((phy_reg >> 1) << 2)

        rvalue = self.n10_pf.bar_read32(0, addr)
        if phy_reg & 0x1:
            rvalue &= ~(0xffff0000)
            rvalue |= data << 16
        else:
            rvalue &= ~(0xffff0000)
            rvalue |= data
        self.n10_pf.bar_write32(0, addr, rvalue)

    def readreg(self, subsystem, reg, custom=False):
        if subsystem == self.NET_PHY_SUBSYSTEM:
            return self.pcs_phy_ioread16( self.lane ,reg >> 2)
        elif subsystem == self.PCI_PHY_SUBSYSTEM:
            return self.pci_phy_read16(reg >> 2)
        elif subsystem == self.CTR_SUBSYSTEM:
            return self.n10_pf.cfg_read32(reg)

    def writereg(self, subsystem, reg, data, custom=False):
        """
        Register write function.

        This is the basic write function to be binded

        Args:
        ----
            adress (TYPE): Address for register to write.
            data (TYPE): data to be written in register with address.

        Return:
        ------
            int: Return zero on sucessfull write .

        """
        if subsystem == self.NET_PHY_SUBSYSTEM:
            return self.pcs_phy_iowrite16( self.lane ,reg >> 2,data)
        elif subsystem == self.PCI_PHY_SUBSYSTEM:
            return self.pci_phy_write16(reg >> 2, data)
        elif subsystem == self.CTR_SUBSYSTEM:
            return self.n10_pf.cfg_write32(reg, data)


def n10_reg_print(n10dev, msg,reg,cnt=1,ishex=True):
    v=n10dev.bar_ioread32(4, reg,cnt)

    if cnt==1:
        reg,rv=v[0][0],v[0][1]
        if ishex:
            print("\t%15s: %08x: 0x%x"%(msg,reg,rv))
        else:
            print("\t%15s: %08x: %d"%(msg,reg,rv))
        return

    if len(msg):
        print(msg)
    for reg,rv in v:
        if ishex:
            print("\t%08x: 0x%x"%(reg,rv))
        else:
            print("\t%08x: %d"%(reg,rv))

def pma_remote_loopback(n10dev):
    print("set pma remote loopback")
    reg,v=0x191d0,0xf
    n10dev.bar_iowrite32(4, reg,v)
    print("\t%08x: 0x%x"%(reg,v))

    reg,v=0x191e0,0x70000000
    n10dev.bar_iowrite32(4, reg,v)
    print("\t%08x: 0x%x"%(reg,v))

    reg,v=0x18008,0x1
    n10dev.bar_iowrite32(4, reg,v)
    print("\t%08x: 0x%x"%(reg,v))

pma_type={}
pma_type[63]="UNKOWN"
pma_type[13]="1000BASE_KX"
pma_type[11]="10G_KR"
pma_type[7]="10G_SR"
pma_type[6]="10G_LR"
pma_type[34]="40G_SR4"
pma_type[32]="40G_KR4"
pma_type[35]="40G_LR4"

def pcs_debug(n10dev):
    for i in range(0,4):
        v=n10dev.pcs_lane_ioread32(0,0x10007)
        v = v & 0xf
        if v in pma_type.keys():
            print("lane{} {} {}".format(i,pma_type[v], v))
        else:
            print("lane%d 0x%x"%(i,v))
    pass

def mac_loopback(n10dev):
    print("set mac loopback")

    for mac_base in [0x60000,0x70000,0x80000,0x90000]:
        reg,v=n10dev.bar_ioread32(4, mac_base + 0x0,1)[0]
        v = v|(1<<0)
        n10dev.bar_iowrite32(4, reg,v |(1<<0))
        print("\t%08x: 0x%x"%(reg,v))

        reg,v=n10dev.bar_ioread32(4, mac_base + 0x4,1)[0]
        v = v|(1<<10)|(1<<0)
        n10dev.bar_iowrite32(4, reg,v |(1<<10)|(1<<0))
        print("\t%08x: 0x%x"%(reg,v))

def tx_counter_debug(n10dev):
    print("tx counters")
    print("ring0-tx:")
    n10_reg_print(n10dev,"len",0x8068,ishex=False)
    n10_reg_print(n10dev,"head",0x806c,ishex=False)
    n10_reg_print(n10dev,"tail",0x8070,ishex=False)

    print("ring1-tx:")
    n10_reg_print(n10dev,"len",0x8068 + 0x100,ishex=False)
    n10_reg_print(n10dev,"head",0x806c + 0x100,ishex=False)
    n10_reg_print(n10dev,"tail",0x8070 + 0x100,ishex=False)

    print("to_1to4_p1::")
    n10_reg_print(n10dev,"emac_in",0x10200,ishex=False)
    n10_reg_print(n10dev,"emac_send",0x10210,ishex=False)

    print("to_1to4_p2:")
    n10_reg_print(n10dev,"sop_pkt",0x10214,ishex=False)
    n10_reg_print(n10dev,"eop_pkt",0x10218,ishex=False)
    n10_reg_print(n10dev,"send_terr",0x1021c,ishex=False)

    print("to_tx_trans(phy):")
    n10_reg_print(n10dev,"in",0x10250,ishex=False)
    n10_reg_print(n10dev,"out",0x10260,ishex=False)

    print("mac:")
    n10_reg_print(n10dev,"tx", 0x1081c,ishex=False);
    n10_reg_print(n10dev,"underflow_err", 0x1087c,ishex=False);
    n10_reg_print(n10dev,"port0_txtrans_sop", 0x10300,ishex=False);
    n10_reg_print(n10dev,"port0_txtrans_eop", 0x10304,ishex=False);
    n10_reg_print(n10dev,"port1_txtrans_sop", 0x10308,ishex=False);
    n10_reg_print(n10dev,"port1_txtrans_eop", 0x1030c,ishex=False);
    n10_reg_print(n10dev,"port2_txtrans_sop", 0x10310,ishex=False);
    n10_reg_print(n10dev,"port2_txtrans_eop", 0x10314,ishex=False);
    n10_reg_print(n10dev,"port3_txtrans_sop", 0x10318,ishex=False);
    n10_reg_print(n10dev,"port3_txtrans_eop", 0x1031c,ishex=False);
    n10_reg_print(n10dev,"tx_empty", 0x10334,ishex=False);
    n10_reg_print(n10dev,"tx_prog_full", 0x10338,ishex=False);
    n10_reg_print(n10dev,"tx_full", 0x1033c,ishex=False);

def rx_counter_debug(n10):
    print("rx counters")

    for nr_port in range(0,4):
        print("emac_rx_trans (port:{}):".format(nr_port))
        n10_reg_print(n10dev,"pkts", 0x18900 + 0x40 * nr_port,ishex=False);
        n10_reg_print(n10dev,"drop", 0x18904 + 0x40 * nr_port,ishex=False);
        n10_reg_print(n10dev,"wdt_err", 0x18908 + 0x40 * nr_port,ishex=False);
        n10_reg_print(n10dev,"code_err", 0x1890c + 0x40 * nr_port,ishex=False);
        n10_reg_print(n10dev,"crc_err", 0x18910 + 0x40 * nr_port,ishex=False);
        n10_reg_print(n10dev,"slen_err", 0x18914 + 0x40 * nr_port,ishex=False);
        n10_reg_print(n10dev,"glen_err", 0x18918 + 0x40 * nr_port,ishex=False);
        n10_reg_print(n10dev,"iph_err", 0x1891c + 0x40 * nr_port,ishex=False);
        n10_reg_print(n10dev,"csum_err", 0x18920 + 0x40 * nr_port,ishex=False);
        n10_reg_print(n10dev,"len_err", 0x18924 + 0x40 * nr_port,ishex=False);
        n10_reg_print(n10dev,"trans_cut_err", 0x18928 + 0x40 * nr_port,ishex=False);
        n10_reg_print(n10dev,"expt_byte_err", 0x1892c + 0x40 * nr_port,ishex=False);
        n10_reg_print(n10dev,">1600Byte", 0x18930 + 0x40 * nr_port,ishex=False);

    print("gather:");
    n10_reg_print(n10dev,"total_in_pkts", 0x18240,ishex=False);
    n10_reg_print(n10dev,"to_nxt_mdodule", 0x18220,ishex=False);
    n10_reg_print(n10dev,"p0-rx", 0x18220,ishex=False);
    n10_reg_print(n10dev,"p1-rx", 0x18224,ishex=False);
    n10_reg_print(n10dev,"p2-rx", 0x18228,ishex=False);
    n10_reg_print(n10dev,"p3-rx", 0x1822c,ishex=False);
    n10_reg_print(n10dev,"p0-drop", 0x18230,ishex=False);
    n10_reg_print(n10dev,"p1-drop", 0x18234,ishex=False);
    n10_reg_print(n10dev,"p2-drop", 0x18238,ishex=False);
    n10_reg_print(n10dev,"p3-drop", 0x1823c,ishex=False);

    print("ip-parse:");
    n10_reg_print(n10dev,"pkg_egree", 0x18294,ishex=False);
    n10_reg_print(n10dev,"L3_len_err", 0x18298,ishex=False);
    n10_reg_print(n10dev,"ip_hdr_err", 0x1829c,ishex=False);
    n10_reg_print(n10dev,"l3-csum-err", 0x182a0,ishex=False);
    n10_reg_print(n10dev,"l4-csum-err", 0x182a4,ishex=False);
    n10_reg_print(n10dev,"sctp-err", 0x182a8,ishex=False);
    n10_reg_print(n10dev,"vlan-err", 0x182ac,ishex=False);
    n10_reg_print(n10dev,"except_short_num", 0x182c4,ishex=False);
    n10_reg_print(n10dev,"ptp", 0x182c8,ishex=False);

    print("to-indecap:");
    n10_reg_print(n10dev,"*in engin*", 0x182d0,ishex=False);
    n10_reg_print(n10dev,"*out engin*", 0x182d4,ishex=False);
    n10_reg_print(n10dev,"to-dma/host", 0x182d8,ishex=False);
    n10_reg_print(n10dev,"to-bmc", 0x182dc,ishex=False);
    n10_reg_print(n10dev,"to-switch", 0x182e0,ishex=False);
    n10_reg_print(n10dev,"bmc+host", 0x182e4,ishex=False);
    n10_reg_print(n10dev,"err_drop", 0x182e8,ishex=False);
    n10_reg_print(n10dev,"plicy_drop", 0x182ec,ishex=False);
    n10_reg_print(n10dev,"dmac_drop", 0x182f0,ishex=False);
    n10_reg_print(n10dev,"bmc_drop", 0x182f4,ishex=False);
    n10_reg_print(n10dev,"sw_drop", 0x182f8,ishex=False);
    n10_reg_print(n10dev,"rm_vlane_num", 0x182fc,ishex=False);

    n10_reg_print(n10dev,"parse debug0", 0x18428,ishex=False);
    n10_reg_print(n10dev,"parse debug1", 0x1842c,ishex=False);
    n10_reg_print(n10dev,"parse debug2", 0x18430,ishex=False);
    n10_reg_print(n10dev,"parse debug3", 0x1843c,ishex=False);
    n10_reg_print(n10dev,"4to1 sop", 0x18438,ishex=False);
    n10_reg_print(n10dev,"4to1 eop", 0x1843c,ishex=False);

    print("dma-2-host:");
    n10_reg_print(n10dev,"fifo equ", 0x00264,ishex=False);
    n10_reg_print(n10dev,"fifo deq", 0x00268,ishex=False);
    n10_reg_print(n10dev,"unexpt_abtring", 0x00114,ishex=False);
    n10_reg_print(n10dev,"pci2host", 0x00288,ishex=False);

    print("rx-ring0:");
    n10_reg_print(n10dev,"head", 0x0803c,ishex=False);
    n10_reg_print(n10dev,"tail", 0x08040,ishex=False);
    n10_reg_print(n10dev,"len", 0x08038,ishex=False);

    print("rx-ring1:");
    n10_reg_print(n10dev,"head", 0x0803c + 0x100 * 1,ishex=False);
    n10_reg_print(n10dev,"tail", 0x00008040 + 0x100 * 1,ishex=False);

def eth_policy_dump(n10dev):
    print("policy1")
    n10_reg_print(n10dev,"", 0x10000 + 0x91d0,1);
    n10_reg_print(n10dev,"", 0x10000 + 0x91e0,4);

    print("\npolicy2")
    n10_reg_print(n10dev,"", 0x10000 + 0x9200,35);

    print("\npolicy3")
    n10_reg_print(n10dev,"", 0x10000 + 0x9290,2);

    print("\npolicy4")
    n10_reg_print(n10dev,"", 0x10000 + 0xc000,0xe00/4);

    print("\npolicy5")
    n10_reg_print(n10dev,"", 0x10000 + 0x92a0,1);
    n10_reg_print(n10dev,"rss-key", 0x10000 + 0x92d0,10);

    print("\ninredit-table0")
    n10_reg_print(n10dev,"", 0x10000 + 0xe000,0x200/4,ishex=False);
    print("\ninredit-table1")
    n10_reg_print(n10dev,"", 0x10000 + 0xe200,0x200/4,ishex=False);
    print("\ninredit-table2")
    n10_reg_print(n10dev,"", 0x10000 + 0xe400,0x200/4,ishex=False);
    print("\ninredit-table3")
    n10_reg_print(n10dev,"", 0x10000 + 0xe600,0x200/4,ishex=False);

    print("\ntc table")
    n10_reg_print(n10dev,"", 0x10000 + 0xe800,0x20/4);
    print("\nvlan proi")
    n10_reg_print(n10dev,"", 0x10000 + 0xe820,0x20/4);
    print("\n port offset")
    n10_reg_print(n10dev,"", 0x10000 + 0xe840,4);
    print("\n rdir mask")
    n10_reg_print(n10dev,"", 0x10000 + 0xe860,1);

def p_pcs_read32(n10dev, nr_lane, reg):
    v=n10dev.pcs_lane_ioread32(nr_lane,reg)
    print("0x%x: 0x%x"%(reg, v))

def rss_debug(n10dev):
    v=n10dev.bar_ioread32(4, 0x192a0,1)
    print("\t%s: 0x%x: 0x%x"%("rss_mrqc_reg",v[0][0], v[0][1]))

    vs=n10dev.bar_ioread32(4, 0x192d0,10)
    print("rss hash key:")
    for reg,v in vs:
        print("\t 0x%08x: 0x%08x"%(reg,v))

if __name__ == "__main__":
    parser = OptionParser(usage="usage: %prog ")
    parser.add_option("-l", "--lane", action="store",
                      dest="lane", help="net lane(0~3)", default="0")
    parser.add_option("-D", "--device", action="store",
                      dest="device", help="pci device", default="0x1000")
    parser.add_option("-v", "--vender", action="store",
                      dest="vender", help="pci device", default="0x8848")
    parser.add_option("", "--debug", action="store_true",
                      dest="debug", help="debug", default=False)
    parser.add_option("-n", "--nr", action="store",
                      dest="nr_fun", help="num of dev", default="0")
    parser.add_option("", "--pci", action="store_true",
                      dest="pci_phy", help="pci phy", default=False)
    parser.add_option("-s", "", action="store",
                      dest="pci_slot", help="pci slot", default="")
    parser.add_option("-m", "--module", action="store",
                      dest="module", help="dma,eth,reg0,serdes,mac", default="")
    parser.add_option("-w", "--write", action="store_false",
                      dest="op_read", help="write/read", default=True)
    parser.add_option("-b", "--bar", action="store",
                      dest="bar", help="bar:0,2,4", default="4")
    parser.add_option("", "--pcs-debug", action="store_true",
                      dest="pcs_debug", help="pcs debug", default=False)
    parser.add_option("", "--link", action="store_true",
                      dest="link", help="link", default=False)

    parser.add_option("", "--pcs", action="store_true",
                      dest="pcs", help="pcs <lane> <reg> [value]", default=False)

    parser.add_option("", "--an-debug", action="store_true",
                      dest="an_debug", help="an_debug", default=False)

    parser.add_option("", "--pma-tx-rx-loopback", action="store_true",
                      dest="pma_tx_rx_loopback", help="pma loopback", default=False)
    parser.add_option("", "--mac-loopback", action="store_true",
                      dest="mac_loopback", help="mac loopback", default=False)

    parser.add_option("", "--policy", action="store_true",
                      dest="policy_dump", help="policy debug", default=False)
    parser.add_option("", "--rss", action="store_true",
                      dest="rss_debug", help="rss debug", default=False)
    parser.add_option("", "--tx_counter", action="store_true",
                      dest="tx_counter", help="tx counters", default=False)
    parser.add_option("", "--rx_counter", action="store_true",
                      dest="rx_counter", help="rx counters", default=False)

    (options, args) = parser.parse_args()
    vender = int(options.vender, 0)
    device = int(options.device, 16)
    options.bar = int(options.bar)
    nr_pf = int(options.nr_fun)
    nr_lane = 0
    g_debug = options.debug
    reg_off = 0
    # set_trace()


    if len(options.module) > 0:
        if "eth" in options.module:
            reg_off = 0x10000
        elif "reg" in options.module:
            reg_off = 0x30000
        elif "serdes" in options.module:
            reg_off = 0x40000
        elif "mac" in options.module:
            reg_off = 0x60000
    
    if options.pci_phy:
        phy_subsys = n10.PCI_PHY_SUBSYSTEM
    else:
        phy_subsys = n10.NET_PHY_SUBSYSTEM
        nr_lane = int(options.lane, 10)

    #set_trace()
    n10dev=n10(vender,device,nr_pf, nr_lane, options.pci_slot)

    if options.mac_loopback:
        mac_loopback(n10dev)

    if options.pcs_debug:
        pcs_debug(n10dev)

    if options.pma_tx_rx_loopback:
        pma_remote_loopback(n10dev)

    if options.tx_counter:
        tx_counter_debug(n10dev)
    if options.rx_counter:
        rx_counter_debug(n10dev)
    if options.rss_debug :
        rss_debug(n10dev)
    if options.policy_dump:
        eth_policy_dump(n10dev)
    if options.link:
        for nr_lane in range(0,4):
            v=n10dev.pcs_lane_ioread32(nr_lane,0x30001)
            v1=n10dev.pcs_lane_ioread32(nr_lane,0x18020)
            print("lane%d: 0x%-8x: 0x%2x 0x18020:0x%04x"%(nr_lane,0x30001,v, v1))
    if options.an_debug:
        p_pcs_read32(n10dev,0,0x10007)
        p_pcs_read32(n10dev,0,0x70000)
        p_pcs_read32(n10dev,0,0x18000)

    if options.pcs:
        nr_lane=int(args[0],10)
        reg=int(args[1],16)
        if len(args) >= 3:
            # write
            v = int(args[2],16)
            print("pcs-lane%d: 0x%-8x: <= 0x%08x"%(nr_lane,reg ,v))
            n10dev.pcs_lane_iowrite32(nr_lane, reg, v)
        else:
            v=n10dev.pcs_lane_ioread32(nr_lane, reg)
            print("pcs-lane%d: 0x%-8x: 0x%08x"%(nr_lane,reg ,v))
            
        exit(0)

    if options.op_read and len(args) >=1:
        regs=args[0]
        rcnt=1
        if len(args)>1:
            rcnt = int(args[1],0)
        for reg in regs.split(","):
            reg=int(reg,0)
            vs=n10dev.bar_ioread32(options.bar,reg + reg_off, rcnt)
            for reg,v in vs:
                print("[bar%d] 0x%-8x: 0x%08x"%(options.bar,reg ,v))
    elif not options.op_read and len(args) >=2:
        reg,v=int(args[0],0),int(args[1],0)
        print("[bar%d] w 0x%-8x <= 0x%x"%(options.bar, reg + reg_off, v))
        n10dev.bar_iowrite32(options.bar, reg + reg_off, v)
        v=n10dev.bar_ioread32(options.bar, reg + reg_off,1)
        print("[bar%d] r 0x%-8x => 0x%x"%(options.bar, reg + reg_off, v[0][1]))

