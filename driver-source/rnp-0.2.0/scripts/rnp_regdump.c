#include <stdio.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <ctype.h>
#include <termios.h>
#include <sys/types.h>
#include <sys/mman.h>

#define MAP_SIZE (unsigned long)(2*1024*1024)
#define MAP_MASK (MAP_SIZE - 1)

int bar0;
int bar2;
int bar4;

#define BAR0 0
#define BAR2 2
#define BAR4 4

struct reg_desc {
    unsigned int bar;
    unsigned int off;
    const char * desc; 
    int no_hex;
};

char* bars[6];
int bar_phy[6];

#define ARRAY_SIZE(arr) (sizeof((arr))/sizeof((arr)[0]))

int get_bar_phy(int device)
{
    char cmd[4096];
    char buf[4096];
    int bar;
    FILE* fp;

    {
        bar = 0;
        sprintf(cmd, "lspci -d 1dab:%x -vv |grep 'Region %d' | awk  '{print $5}'",device, bar);
        printf("cmd:%s\n",cmd);
        fp = popen(cmd,"r");
        fgets(buf, sizeof(buf),fp);
        pclose(fp);
        bar0 = strtoul(buf, 0,16);
        bar_phy[BAR0]= bar0;
    }
    {
        bar = 2;
        sprintf(cmd, "lspci -d 1dab:%x -vv |grep 'Region %d' | awk  '{print $5}'",device, bar);
        printf("cmd:%s\n",cmd);
        fp = popen(cmd,"r");
        fgets(buf, sizeof(buf),fp);
        pclose(fp);
        bar2 = strtoul(buf, 0,16);
        bar_phy[BAR2]= bar2;
    }
    {
        bar = 4;
        sprintf(cmd, "lspci -d 1dab:%x -vv |grep 'Region %d' | awk  '{print $5}'",device, bar);
        printf("cmd:%s\n",cmd);
        fp = popen(cmd,"r");
        fgets(buf, sizeof(buf),fp);
        pclose(fp);
        bar4 = strtoul(buf, 0,16);
        bar_phy[BAR4]= bar4;
    }

    printf("1dab:%x bar0:0x%x bar2:0x%x bar4:0x%x\n",device, bar0,bar2,bar4);

    sprintf(cmd,"setpci -v -d 1dab:%x COMMAND=0x6",device);
    system(cmd);

    return 0;
}

int map_bar()
{
    unsigned int map_size,map_mask;
    char *map_base; 
    int fd;

    if((fd = open("/dev/mem", O_RDWR | O_SYNC)) == -1) 
        return -1;
    
#if 0
    /* Map bar0*/
    map_base = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, bar0 & ~MAP_MASK);
    if(map_base == (void *) -1) {
        printf("error mmap\n");
        return -1;
    }
    bars[BAR0] = map_base;

    /* Map bar2*/
    map_base = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, bar2 & ~MAP_MASK);
    if(map_base == (void *) -1) {
        printf("error mmap\n");
        return -1;
    }
    bars[BAR2] = map_base;
#endif

    /* Map bar4*/

    map_size = 2*1024*1024;
    map_mask = (map_size - 1);
    map_base = mmap(0, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, bar4 & ~map_mask);
    if(map_base == (void *) -1) {
        printf("error mmap\n");
        return -1;
    }
    bars[BAR4] = map_base;

    return 0;
}


struct reg_desc reg0_nic[] = {
    {BAR4,0x30000 + 0x0000,"nic version"},
    {BAR4,0x30000 + 0x0004,"nic config"},
    {BAR4,0x30000 + 0x0008,"nic status"},
    {BAR4,0x30000 + 0x000C,"nic dummy"},
    {BAR4,0x30000 + 0x0010,"nic reset_n"},
};


struct reg_desc mac_regs[] = {
    {BAR4,0x60000 + 0x0000,"MAC_TX_CFG"},
    {BAR4,0x60000 + 0x0004,"MAC_RX_CFG"},
    {BAR4,0x60000 + 0x0008,"MAC_PKT_FLT"},
    {BAR4,0x60000 + 0x00d0,"MAC_LPI_CTRL"},
    {BAR4,0x60000 + 0x0070,"MAC_TX_FLOWCTRL"},
    {BAR4,0x60000 + 0x0090,"MAC_RX_FLOWCTRL"},
    {BAR4,0x60000 + 0x0120,"MAC_HW_FEATURE"},
};

struct reg_desc ring_vectors_regs[] = {
    {BAR4,0xa4000 + 0x0000,"ring-vector"},
    {BAR4,0xa4000 + 0x0004,"ring-vector"},
    {BAR4,0xa4000 + 0x0008,"nic status"},
    {BAR4,0xa4000 + 0x000c,"nic dummy"},
};

struct reg_desc dma_cfg_reg[] = {
    {BAR4,0x0000,"dma version"},
    {BAR4,0x0004,"dma config"},
    {BAR4,0x0008,"dma status"},
    {BAR4,0x000C,"dma dummy"},
    {BAR4,0x0010,"dma axi enable"},
    {BAR4,0x0014,"dma axi status"},
};

struct reg_desc dma_ring_reg[] = {
    {BAR4,0x8010,"dma rx start"},
    {BAR4,0x8014,"dma rx ready"},
    {BAR4,0x8018,"dma tx start"},
    {BAR4,0x801C,"dma tx ready"},
    {BAR4,0x8020,"int status"},
    {BAR4,0x8024,"int mask"},
    {BAR4,0x8028,"int clear"},

    {BAR4,0x8030,"dma rx desc phy hi"},
    {BAR4,0x8034,"dma rx desc phy lo"},
    {BAR4,0x8038,"dma rx desc count"},
    {BAR4,0x803C,"dma rx desc head"},
    {BAR4,0x8040,"dma rx desc tail"},
    {BAR4,0x8044,"dma rx desc fetch ctrl"},
    {BAR4,0x8048,"dma rx int delay timer"},
    {BAR4,0x804C,"dma rx int delay pktcnt"},
    {BAR4,0x8050,"dma rx arb def lvl"},
    {BAR4,0x8054,"dma rx desc timeout th"},

    {BAR4,0x8060,"dma tx desc phy hi"},
    {BAR4,0x8064,"dma tx desc phy lo"},
    {BAR4,0x8068,"dma tx desc count"},
    {BAR4,0x806C,"dma tx desc head"},
    {BAR4,0x8070,"dma tx desc tail"},
    {BAR4,0x8074,"dma tx desc fetch ctrl"},
    {BAR4,0x8078,"dma tx int delay timer"},
    {BAR4,0x807C,"dma tx int delay pktcnt"},
    {BAR4,0x8080,"dma tx arb def lvl"},
    {BAR4,0x8084,"dma tx flow ctrl th"},
    {BAR4,0x8088,"dma tx flow ctrl tm"},
};


struct reg_desc probe_debug_regs [] = {
    {BAR4,0x0100,"dma_axi_rx"},
    {BAR4,0x0104,"dma_axi_rx"},
    {BAR4,0x0108,"dma_queue_rx"},
    {BAR4,0x010C,"dma_queue_rx"},
    {BAR4,0x0110,"dma_ctrl_rx"},
    {BAR4,0x0114,"dma_ctrl_rx"},
    {BAR4,0x0118,"dma_ififo_rx",1},
    {BAR4,0x011C,"dma_ififo_rx"},
    {BAR4,0x0120,"dma_ofifo_rx",1},
    {BAR4,0x0124,"dma_ofifo_rx"},
    {BAR4,0x0128,"dma_buf_rx_mac",1},
    {BAR4,0x012C,"dma_buf_rx_mac"},
    {BAR4,0x0130,"dma_buf_rx_swc"},
    {BAR4,0x0134,"dma_buf_rx_swc"},
    {BAR4,0x0138,"dma_axi_tx"},
    {BAR4,0x013C,"dma_axi_tx"},
    {BAR4,0x0140,"dma_queue_tx"},
    {BAR4,0x0144,"dma_queue_tx"},
    {BAR4,0x0148,"dma_ctrl_tx"},
    {BAR4,0x014C,"dma_ctrl_tx"},
    {BAR4,0x0150,"dma_tso_tx0(state_status)"},
    {BAR4,0x0154,"dma_tso_tx0(fifo_status)"},
    {BAR4,0x0158,"dma_tso_tx1(state_status)"},
    {BAR4,0x015C,"dma_tso_tx1(fifo_status)"},
    {BAR4,0x0160,"dma_tso_tx2(state_status)"},
    {BAR4,0x0164,"dma_tso_tx2(fifo_status)"},
    {BAR4,0x0168,"dma_tso_tx3(state_status)"},
    {BAR4,0x016C,"dma_tso_tx3(fifo_status)"},
    {BAR4,0x0170,"veb_top"},
    {BAR4,0x0174,"veb_top"},
    {BAR4,0x0178,"dma_scatter"},
    {BAR4,0x017C,"dma_scatter"},
};

struct reg_desc counter_dubug[] = {
    {BAR4,0x0200,"count_dma_queue_tx_0: tx irq cnt",1},
    {BAR4,0x0204,"count_dma_ctrl_tx_0: port0 tx pkg cnt",1},
    {BAR4,0x0214,"count_eth_tso_offload_0_0:port0 in pkts",1},
    {BAR4,0x0218,"count_eth_tso_offload_0_1:port0 out pkts",1},
    {BAR4,0x0234,"count_veb_top_0:port0 tx in pkgs ***",1},
    {BAR4,0x0244,"count_veb_top_4:port0 tx out pkgs ***",1},

    {BAR4,0x0208,"count_dma_ctrl_tx_1: port1 tx pkg cnt",1},
    {BAR4,0x020c,"count_dma_ctrl_tx_2: port2 tx pkg cnt",1},
    {BAR4,0x0210,"count_dma_ctrl_tx_3: port3 tx pkg cnt",1},
    {BAR4,0x021c,"count_eth_tso_offload_1_0:port1 in pkts",1},
    {BAR4,0x0220,"count_eth_tso_offload_1_1:port1 out pkts",1},
    {BAR4,0x0224,"count_eth_tso_offload_2_0:port2 in pkts",1},
    {BAR4,0x0228,"count_eth_tso_offload_2_1:port2 out pkts",1},
    {BAR4,0x022c,"count_eth_tso_offload_3_0:port3 in pkts",1},
    {BAR4,0x0230,"count_eth_tso_offload_3_1:port3 out pkts",1},
    {BAR4,0x0238,"count_veb_top_1",1},
    {BAR4,0x023c,"count_veb_top_2",1},
    {BAR4,0x0240,"count_veb_top_3",1},
    {BAR4,0x0248,"count_veb_top_5",1},
    {BAR4,0x024c,"count_veb_top_6",1},
    {BAR4,0x0250,"count_veb_top_7",1},
    {BAR4,0x0254,"count_veb_top_8",1},
    {BAR4,0x0258,"count_veb_top_9",1},
    {BAR4,0x025c,"count_veb_top_10",1},
    {BAR4,0x0260,"count_veb_top_11",1},
    {BAR4,0x0264,"count_dma_buf_rx_mac_0",1},
    {BAR4,0x0268,"count_dma_buf_rx_mac_1",1},
    {BAR4,0x026c,"count_dma_buf_rx_swc_0",1},
    {BAR4,0x0270,"count_dma_buf_rx_swc_1",1},
    {BAR4,0x0274,"count_dma_ififo_rx_0",1},
    {BAR4,0x0278,"count_dma_ififo_rx_1:",1},
    {BAR4,0x027c,"count_dma_ofifo_rx_0:rx data in pkg cnt",1},
    {BAR4,0x0280,"count_dma_ofifo_rx_1:rx data output pkg cnt",1},
    {BAR4,0x0284,"count_dma_ctrl_rx_0:pcie read req cnt",1},
    {BAR4,0x0288,"count_dma_ctrl_rx_1:pcie write req cnt",1},
    {BAR4,0x028c,"count_dma_ctrl_rx_2:received_desc_wr",1},
    {BAR4,0x0290,"count_dma_ctrl_rx_3: cur_desc_rd",1},
    {BAR4,0x0294,"count_dma_queue_rx_0:rx irq count",1},
    {BAR4,0x0298,"0",1},
    {BAR4,0x029c,"0",1},
};

void dump_regs(struct reg_desc* desc, int cnt, char* msg,int off)
{
    int i;
    char* base;
    unsigned int val;
    int bar;

    printf("\n%s\n", msg);

    for(i=0;i<cnt;i++){
        bar = desc[i].bar;
        base =  bars[bar];

        val = *((volatile unsigned int *)(base + desc[i].off + off));
        if(desc[i].no_hex)
            printf("%8x:   %-8u  \t:%s\n", bar_phy[bar] + desc[i].off + off, val, desc[i].desc);
        else
            printf("%8x: 0x%-8x  \t:%s\n", bar_phy[bar] + desc[i].off + off, val, desc[i].desc);

    }
    return;
}

#define DO_DUMP_REGS(arr, msg,off) dump_regs((arr),ARRAY_SIZE(arr),(msg),(off));

int main(int argc, char const* argv[])
{
    get_bar_phy(0x7001);

    if( map_bar() ) {
        return -1;
    }

    DO_DUMP_REGS(reg0_nic,"== nic reg0 ==",0);
    DO_DUMP_REGS(mac_regs,"== mac ==",0);
    DO_DUMP_REGS(ring_vectors_regs,"== ring vector ==",0);

    DO_DUMP_REGS(dma_cfg_reg,"== dma cfg ==",0);

    DO_DUMP_REGS(dma_ring_reg,"== dma ring0 ==",0);
    DO_DUMP_REGS(dma_ring_reg,"== dma ring1 ==",0x100);

    DO_DUMP_REGS(probe_debug_regs,"== probe_debug_regs ==",0);
    DO_DUMP_REGS(counter_dubug,"== counter_dubug ==",0);
    
    return 0;
}
