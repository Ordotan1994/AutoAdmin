#!/usr/bin/env bash

Checker=0
#Necessary Directories
rm -r /bin/AutoAdmin
if [ $? -eq 0 ]
then
	((Checker++))
fi

rm -r /mnt/backups
if [ $? -eq 0 ]
then
        ((Checker++))
fi

rm -r /var/log/AutoAdmin
if [ $? -eq 0 ]
then
        ((Checker++))
fi

rm -r /etc/AutoAdmin
if [ $? -eq 0 ]
then
        ((Checker++))
fi

#Timing System
cat /var/spool/cron/crontabs/root | grep -q -w '@reboot sleep 120 ; /bin/AutoAdmin/AAinit.sh'
if [ $? -eq 0 ]
then
        sed -i '/@reboot sleep 120 ; \/bin\/AutoAdmin\/AAinit\.sh/d' /var/spool/cron/crontabs/root
fi

#Unistall verification

if [ $Checker -eq 4 ]
then
	echo "AutoAdmin was unistalled successfully"
else
	echo "Error was accured, please remove manualy the following directories: /etc/AutoAdmin, /var/log/AutoAdmin, /mnt/backups, /bin/AutoAdmin"
fi
