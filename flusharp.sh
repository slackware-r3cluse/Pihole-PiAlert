#!/bin/bash
#
# Flushing Pihole ARP tables
#

#
# set variable

today=`date '+%Y_%m_%d'`;

#
# flush APP table

sudo ip -s -s neigh flush all

#
# Wipe out entire PiHole database

sudo service pihole-FTL stop
cd ~
sqlite3 /etc/pihole/pihole-FTL.db ".backup main pihole-FTL.db.bak.$today"
sudo -u pihole sqlite3 /etc/pihole/pihole-FTL.db "DELETE FROM network"
sudo service pihole-FTL start


