#!/bin/bash
#
# Quick script to flush pihole DHCP leases

sudo service dhcpcd stop
sudo rm /etc/pihole/dhcp.leases
sudo service dhcpcd start

