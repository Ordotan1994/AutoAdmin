#!/usr/bin/env bash

Checker=0
#Necessary Directories
rm -rf /bin/AutoAdmin
if [ $? -eq 0 ]
then
	$Checker+=1
fi

rm -rf /mnt/backups
if [ $? -eq 0 ]
then
        $Checker+=1
fi

rm -rf /var/log/AutoAdmin
if [ $? -eq 0 ]
then
        $Checker+=1
fi

rm -rf /etc/AutoAdmin
if [ $? -eq 0 ]
then
        $Checker+=1
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
