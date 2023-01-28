#!/usr/bin/env bash

#Necessary Directories
mkdir -p /bin/AutoAdmin
mkdir -p /mnt/backups
mkdir -p /var/log/AutoAdmin
mkdir -p /etc/AutoAdmin

#Extracting the scripts and config files
cp config.conf White4Bak.txt /etc/AutoAdmin
cp AAinit.sh Analytics.sh Backup.sh Monitoring_resource.sh Rotate.sh Update_auto.sh Uptime.sh Wakeup.sh /bin/AutoAdmin

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
