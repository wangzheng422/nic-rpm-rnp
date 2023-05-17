CONFIG_MODULE_SIG=n
ccflags-y += -I$(PWD)/../../ -Wno-unused-function -Wno-unused=variable -Wno-unused-label -Wno-unused-variable

ifneq ($(KERNELRELEASE),)
	obj-m += n10_read_fun_id.o
else
	KERNELDIR ?= /lib/modules/$(shell uname -r)/build
	PWD := $(shell pwd)

default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules
endif

clean:
	rm -f *.o *.ko Module.symvers modules.order *.mod.c .*.cmd
