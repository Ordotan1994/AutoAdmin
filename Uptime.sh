#!/usr/bin/env bash

logger -s -i -t $0 -p user.info "Starting.." &>> /root/AutoAdmin/log/AutoAdmin.log

#Config file
source ./Auconfig.conf

#Core
while true
do
upTime=$(date "+%s" -d "(uptime -s)")
sysTime=$(date "+%s")
awakeTime=$(($sysTime - $upTime))
if [ $awakeTime -gt $uptimeInterval ]
then
	(echo "Subject: System_Uptime_Alert"; echo "The system is $(uptime -p)") | ssmtp $Mail
	logger -s -i -t $0 -p user.info "Uptime exceeded 24 Hours" &>> /root/AutoAdmin/log/AutoAdmin.log
	sleep 3600

else
	sleep 3600

fi
done
