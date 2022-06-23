#!/bin/bash
# A quick and dirty update script
# sudo password may be required many times depending on how long this takes
#
# Written, and posted to github by slackware-r3cluse
#
# Use at your own discresion/peril
#

#
# Update the OS
sudo apt update
sudo apt -y full-upgrade
sudo apt -y autoremove

#
# Update PiHole system and adlists
pihole -up
pihole -g

#
# Pi.Alert
# Remove old backup files
find ~/ -atime +30 -name 'pialert_update_backup*' -exec rm {} \;

# Update Pi.Alert
curl -sSL https://github.com/pucherot/Pi.Alert/raw/main/install/pialert_update.sh | bash

# Fix Pi.Alert
# This is necessary to get the vendor IDs
# The old file uses HTTP instead of HTTPS and this creates null files as the IEEE does not accept HTTP requests
sed -i 's/http:/https:/' ~/pialert/back/update_vendors.sh
~/pialert/back/pialert.py update_vendors_silent
~/pialert/back/pialert.py internet_IP
~/pialert/back/pialert.py 1

# Sometimes the database gets locked due to permissions
sudo chgrp -R www-data ~/pialert/db
chmod -R 770 ~/pialert/db

#
# lighttpd
# Remove old backup files
sudo find /etc/lighttpd/ -atime +30 -name 'lighttpd.bak*' -exec rm {} \;

# Create new backup file
today=`date '+%Y_%m_%d'`;
filename="/etc/lighttpd/lighttpd.bak.$today"
sudo cp /etc/lighttpd/lighttpd.conf $filename;

# Change lighttpd to port 8089
sudo sed -i 's/server.port                 = .*/server.port                 = 8089/' /etc/lighttpd/lighttpd.conf

#
# Reboot
sudo reboot now
