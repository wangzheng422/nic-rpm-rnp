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
  
#define FATAL do { fprintf(stdout, "Error at line %d, file %s (%d) [%s]\n", \
  __LINE__, __FILE__, errno, strerror(errno)); exit(1); } while(0)
 
#define MAP_SIZE getpagesize()
#define MAP_MASK (MAP_SIZE - 1)

void print_bin(unsigned int v)
{
    int i;
    printf("v: 0x%08x\n",v);

    for(i=0;i<32;i++){
        printf(" %-2d", ((v>>(31-i))&0x1)?1:0 );
    }
    printf("\n");
    for(i=31;i>=0;i--){
        printf("|%-2d",i);
    }
    printf("\n");
}

int main(int argc, char **argv) 
{
    int fd,i;
    void *map_base, *virt_addr; 
	unsigned int read_result, writeval,rcnt=1;
	long target;
	int access_type = 'w';
    int do_write = 0;
    char* op;
    int hex_print=1;
	
	if(argc < 3) {
		fprintf(stdout, "\nUsage:\t%s [r[bwh]|w] { address }  [ data ] [count] ]\n"
			"\taddress : memory address to act upon\n"
			"\tcnt     : data to read cnt\n\n",
			argv[0]);
		exit(1);
	}
	op = argv[1];
	target = strtoul(argv[2], 0, 0);


    if(op[0] == 'w'){
        do_write = 1;

		writeval = strtoul(argv[3], 0, 0);
    }else{//do read
        do_write = 0;
        if(argc >=4){
		    rcnt = strtoul(argv[3], 0, 0);
        }
    }
    if(strlen(op)>1){
	    access_type = op[1];
        if(access_type == 'W' || access_type == 'H' || access_type=='B' ){
            hex_print = 0;
        }
    }

    if((fd = open("/dev/mem", O_RDWR | O_SYNC)) == -1) FATAL;
    //fprintf(stdout,"/dev/mem opened.\n"); 
    fflush(stdout);
    
    /* Map one page */
    map_base = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, target & ~MAP_MASK);
    if(map_base == (void *) -1) FATAL;
    fflush(stdout);
    
    virt_addr = map_base + (target & MAP_MASK);
    if(!do_write){
        for(i=0;i<rcnt;i++){
            switch(access_type) {
                case 'b':
                    read_result = ((unsigned char *) virt_addr)[i];
                    if(hex_print)
                        fprintf(stdout,"0x%08lX: 0x%02X\n", target + i*1,read_result); 
                    else
                        fprintf(stdout,"0x%08lX: %u\n", target + i*1,read_result); 
                    break;
                case 'h':
                    read_result = ((unsigned short *) virt_addr)[i];
                    if(hex_print)
                        fprintf(stdout,"0x%08lX: 0x%04X\n", target + i*2,read_result); 
                    else
                        fprintf(stdout,"0x%08lX: %u\n", target + i*2,read_result); 
                    break;
                default:
                    read_result = ((unsigned int *) virt_addr)[i];
                    if(hex_print)
                        fprintf(stdout,"0x%08lX: 0x%08X\n", target + i*4,read_result); 
                    else
                        fprintf(stdout,"0x%08lX: %u\n", target + i*4,read_result); 
                    break;
            }
        }
        fflush(stdout);
    }else{
        writeval = strtoul(argv[3], 0, 0);

        printf("0x%lX: <= 0x%X\n", target,writeval); 
        switch(access_type) {
            case 'b':
                *((unsigned char *) virt_addr) = writeval;
                //read_result = *((unsigned char *) virt_addr);
                break;
            case 'h':
                *((unsigned short *) virt_addr) = writeval;
                //read_result = *((unsigned short *) virt_addr);
                break;
            default:
                *((unsigned int *) virt_addr) = writeval;
                //read_result = *((unsigned int *) virt_addr);
                break;
        }
        fflush(stdout);
    }
	
	if(munmap(map_base, MAP_SIZE) == -1) FATAL;
    close(fd);
    return read_result;
}

