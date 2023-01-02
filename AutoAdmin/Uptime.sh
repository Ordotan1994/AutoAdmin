#!/bin/bash

logger -s -i -t $0 -p user.info "Starting.." &>> /root/AutoAdmin/$(date +%d-%m-%y)-log.txt

#Core
while true
do
upTime=$(date "+%s" -d "(uptime -s)")
sysTime=$(date "+%s")
awakeTime=$(($sysTime - $upTime))
Mail="orwallla@gmail.com"
if [ $awakeTime -gt 86400 ]
then
	(echo "Subject: System_Uptime_Alert"; echo "The system is $(uptime -p)") | ssmtp $Mail
	logger -s -i -t $0 -p user.info "Uptime exceeded 24 Hours" &>> /root/AutoAdmin/$(date +%d-%m-%y)-log.txt
	sleep 3600
else
	sleep 3600
fi
done
