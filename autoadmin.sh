#!/usr/bin/env bash

#Necessary Directories
mkdir -p /bin/AutoAdmin
mkdir -p /mnt/backups
mkdir -p /var/log/AutoAdmin
mkdir -p /etc/AutoAdmin

#Extracting the scripts and config files
tar -xzvf AutoAdmin.tar.gz
mv config.conf White4Bak.txt /etc/AutoAdmin
mv AAinit.sh Analytics.sh Backup.sh Monitoring_resource.sh Rotate.sh Update_auto.sh Uptime.sh Wakeup.sh /bin/AutoAdmin

#Giving running permissions to the scripts
chown root /bin/AutoAdmin/*.sh
chmod +x /bin/AutoAdmin/*.sh

#Timing System
echo "@reboot sleep 120 ; /root/AutoAdmin/AAinit" >> /var/spool/cron/crontabs/root
