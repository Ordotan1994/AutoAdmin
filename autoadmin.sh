#!/usr/bin/env bash

# Copyright (c) 2023 Or Dotan - https://github.com/Ordotan1994/AutoAdmin

#Necessary Directories
mkdir -p /bin/AutoAdmin
mkdir -p /mnt/backups
mkdir -p /var/log/AutoAdmin
mkdir -p /etc/AutoAdmin

#Extracting the scripts and config files
cp config/* /etc/AutoAdmin
cp scripts/* /bin/AutoAdmin

#Giving running permissions to the scripts
chown root /bin/AutoAdmin/*.sh
chmod +x /bin/AutoAdmin/*.sh

#Timing System
cat /var/spool/cron/crontabs/root | grep -q -w '@reboot sleep 120 ; /bin/AutoAdmin/AAinit.sh'
if [ $? -eq 1 ]
then
	echo "@reboot sleep 120 ; /bin/AutoAdmin/AAinit.sh" >> /var/spool/cron/crontabs/root
fi

#alert regading installation
echo "AutoAdmin is successfully installed."
