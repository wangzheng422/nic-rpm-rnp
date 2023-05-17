#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>
#include <linux/pci.h>

#include <linux/iommu.h>
#include <linux/aer.h>
#include <linux/if_ether.h>
#include <linux/skbuff.h>
#include <linux/spinlock.h>
#include <linux/interrupt.h>
#include <linux/slab.h>
#include <linux/time.h>
#include <linux/delay.h>
#include <linux/kthread.h>

static int enable_sriovcnt = 64;
module_param(enable_sriovcnt, int,0660);

#define DRV_NAME "pf_vf_fun_test"

#define VF_FLAG_BIT     (11)
#define PF_FLAG_BIT     (10)
#define VF_NUM_MASK     ((1<<VF_FLAG_BIT)-1)
#define is_pf(fun_num)  (((fun_num)&(1<<VF_FLAG_BIT)) ==0?1:0)
#define is_vf(fun_num)  ((((fun_num)&(1<<VF_FLAG_BIT)))? 1:0)
#define nr_pf(fun_num)  (((fun_num) >> PF_FLAG_BIT) &0x1)
#define nr_vf(fun_num)  (((fun_num) >> 4) &0b111111)

static inline unsigned int tsrn10_rd_reg( void* reg) 
{

    unsigned int v = ioread32((void *)(reg));
    //printk(" rd-reg: %p ==> 0x%08x\n", reg, v);
    return v;
}
#define TRACE() printk("%s:%d\n", __func__,__LINE__)

#define tsrn10_wr_reg(reg, val) \
    do{                                \
        printk(" wd-reg: %p <== 0x%08x \t#%-4d\n",(reg), (val), __LINE__); \
        iowrite32((val), (void *)(reg)); \
    }while(0)

struct tsrn10_eth_adapter{
    char *mem_resource[6];
    struct pci_dev *pdev;
};

void read_fun_id_test(struct pci_dev *pdev, struct tsrn10_eth_adapter* adapter)
{
    char*bar0 = adapter->mem_resource[0];
    char*bar4 = adapter->mem_resource[4];
    int fun;
#define VF_NUM 0xa3000

    fun = tsrn10_rd_reg(bar4 + VF_NUM);

    if(pdev->device == 0x7001){
        printk("\n\n==%s pf0    0x%x, vfnum=0x%x\n\n",pci_name(pdev), VF_NUM, fun);
    }
    if(pdev->device == 0x7002){
        printk("\n\n==%s pf1    0x%x, vfnum=0x%x\n\n",pci_name(pdev),VF_NUM, fun);
    }
    if(pdev->device == 0x8001){
        printk("\n\n==%s pf0-vf 0x%x, vfnum=0x%x\n\n",pci_name(pdev),VF_NUM, fun);
    }
    if(pdev->device == 0x8002){
        printk("\n\n==%s pf1-vf 0x%x, vfnum=0x%x\n\n",pci_name(pdev),VF_NUM, fun);
    }

}

// use managed resource api, resource will be auto removed when drv exit
static int tsrn10_probe_one(struct pci_dev *pdev, const struct pci_device_id *id) 
{
    int err = 0;
    struct tsrn10_eth_adapter* adapter;

    printk("\n\n %s ....\n", __func__);

    adapter = devm_kzalloc(&pdev->dev, sizeof(*adapter), GFP_KERNEL);
    if (!adapter)
        return -ENOMEM;
    pci_set_drvdata(pdev, adapter);
    adapter->pdev = pdev;


    /* enable PCI device */
    if ( (err = pcim_enable_device(pdev))) {
        dev_err(&pdev->dev,"pcim_enable_device faild:err:%d\n", err);
        return err;
    }

    // iomap bar0 + bar2 + bar4
    adapter->mem_resource[0] = pcim_iomap(pdev,0, 0);
    adapter->mem_resource[2] = pcim_iomap(pdev,2, 0);
    adapter->mem_resource[4] = pcim_iomap(pdev,4, 0);
    printk("[pf bar0]:%p 0x%llx len=%d\n",adapter->mem_resource[0],(unsigned long long)pci_resource_start(pdev, 0), (int)pci_resource_len(pdev, 0)/1024);
    printk("[pf bar2]:%p 0x%llx len=%d\n",adapter->mem_resource[2],(unsigned long long)pci_resource_start(pdev, 2), (int)pci_resource_len(pdev, 2)/1024);
    printk("[pf bar4]:%p 0x%llx len=%d\n",adapter->mem_resource[4],(unsigned long long)pci_resource_start(pdev, 4), (int)pci_resource_len(pdev, 4)/1024);

    if(pdev->device != 0x8001 && pdev->device != 0x8002 ){
        err = pci_enable_sriov(pdev, enable_sriovcnt);
        if (err) {
            dev_err(&pdev->dev, "failed to enable PCI sriov %d\n", err);
            return err;
        }
        dev_info(&pdev->dev, "Enabled VF(s) %d\n", enable_sriovcnt);
    }

    read_fun_id_test(pdev, adapter);

    return err;
}

static void tsrn10_remove_one(struct pci_dev *pdev) 
{
    pci_disable_sriov(pdev);

    return;
}

static pci_ers_result_t tsrn10_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
{
    if (pdev->is_virtfn)
        return PCI_ERS_RESULT_NONE;

    dev_info(&pdev->dev, "PCI error detected, state(=%d)!!\n", state);

    return PCI_ERS_RESULT_DISCONNECT;
}

static const struct pci_error_handlers tsrn10_err_handlers = {
    .error_detected = tsrn10_pci_error_detected,
};

static const struct pci_device_id tsrn10_ids[] = {
    {PCI_DEVICE(0x1DAB, 0x7001)},
    {PCI_DEVICE(0x1DAB, 0x7002)},
    {PCI_DEVICE(0x1DAB, 0x8001)},
    {PCI_DEVICE(0x1DAB, 0x8002)},
    {}
};
MODULE_DEVICE_TABLE(pci, tsrn10_ids);

static struct pci_driver tsrn10_drv = {
    .name     = DRV_NAME,
    .id_table = tsrn10_ids,
    .probe    = tsrn10_probe_one,
    .remove   = tsrn10_remove_one,
    .err_handler = &tsrn10_err_handlers,
};

module_pci_driver(tsrn10_drv);


MODULE_DESCRIPTION("Driver for tsrn10");
MODULE_LICENSE("GPL");
