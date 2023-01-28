#!/usr/bin/env bash

#Necessary Directories
rm -rf /bin/AutoAdmin
rm -rf /mnt/backups
rm -rf /var/log/AutoAdmin
rm -rf /etc/AutoAdmin

#Timing System
cat /var/spool/cron/crontabs/root | grep -q -w '@reboot sleep 120 ; /bin/AutoAdmin/AAinit.sh'
if [ $? -eq 0 ]
then
        sed -i '/@reboot sleep 120 ; \/bin\/AutoAdmin\/AAinit\.sh/d' /var/spool/cron/crontabs/root
fi
