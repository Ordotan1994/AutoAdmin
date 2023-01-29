#!/usr/bin/env bash

# Copyright (c) 2023 Or Dotan - https://github.com/Ordotan1994/AutoAdmin

logger -s -i -t $0 -p user.info "Starting.." &>> /var/log/AutoAdmin/AutoAdmin.log

#Config file
source /etc/AutoAdmin/config.conf

#Core
while true
do
upTime=$(date "+%s" -d "(uptime -s)")
sysTime=$(date "+%s")
awakeTime=$(($sysTime - $upTime))
if [ $awakeTime -gt $uptimeInterval ]
then
	(echo "Subject: System_Uptime_Alert"; echo "The system is $(uptime -p)") | ssmtp $Mail
	logger -s -i -t $0 -p user.info "Uptime exceeded 24 Hours" &>> /var/log/AutoAdmin/AutoAdmin.log
	sleep 3600

else
	sleep 3600

fi
done
