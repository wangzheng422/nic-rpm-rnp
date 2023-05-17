#!/bin/bash

if [[ "$1" == "cli" ]];then
    MYIP=1.2.3.8
    DSTIP=1.2.3.3
else
    MYIP=1.2.3.3
    DSTIP=1.2.3.8
fi


MADDR=239.192.97.105

omping -m $MADDR -p 9106 $MYIP $DSTIP
