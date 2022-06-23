#!/bin/bash
#
# Flushing Pihole ARP tables
#

#
# set variable

today=`date '+%Y_%m_%d'`;

#
# Flush APP table

sudo ip -s -s neigh flush all

#
# Flush ARP Cache

interfaces=$( arp -n | awk ' NR == 1 {next} {interfaces[$5]+=1} END {for (interface in interfaces){print(interface)}} '); for interface in $interfaces; do echo "Clearing ARP cache for $interface"; sudo ip link set arp off dev $interface; sudo ip link set arp on  dev $interface; done

#
# Wipe out entire PiHole database

sudo service pihole-FTL stop
cd ~
sqlite3 /etc/pihole/pihole-FTL.db ".backup main pihole-FTL.db.bak.$today"
sudo -u pihole sqlite3 /etc/pihole/pihole-FTL.db "DELETE FROM network"
sudo service pihole-FTL start


