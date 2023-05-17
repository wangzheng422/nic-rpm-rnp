ifconfig br0 down
ifconfig br1 down
brctl delbr br0
brctl delbr br1

brctl addbr br0
brctl addbr br1
ifconfig enp179s0f0 mtu 9700
ifconfig enp179s0f1 mtu 9700
ifconfig enp179s0f2 mtu 9700
ifconfig enp179s0f3 mtu 9700
brctl addif br0 enp179s0f0
brctl addif br0 enp179s0f1
brctl addif br1 enp179s0f2
brctl addif br1 enp179s0f3
ifconfig br0 up
ifconfig br1 up

