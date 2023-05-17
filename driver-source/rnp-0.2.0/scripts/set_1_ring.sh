#!/bin/bash
sudo ethtool -L rnp00 combined 1
sudo ethtool -L rnp10 combined 1
./set_irq_affinity -x 1 rnp00
./set_irq_affinity -x 2 rnp10

