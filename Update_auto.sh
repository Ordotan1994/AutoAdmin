#!/usr/bin/env bash
logger -s -i -t $0 -p user.info "Starting.." &>> /root/AutoAdmin/log/AutoAdmin.log

#Config file
source ./Auconfig.conf

while true
do
#System Parametars
	lastUpdate="$(stat -c %Y '/var/cache/apt')"
	sysDate="$(date +'%s')"
	interval=$(($sysDate - $lastUpdate))
#core
	if [ $interval -gt $updateInterval ]
	then
		apt update && apt full-upgrade -y
		if [ $? -eq 0 ]
		then
			(echo -e "Subject: System_Update_Alert\n\n"; echo -e "The system was fully updated at $(date)") | ssmtp orwallla@gmail.com
			logger -s -i -t $0 -p user.info "The system was fully updated at $(date)" &>> /root/AutoAdmin/log/AutoAdmin.log
		else
			(echo -e "Subject: System_Update_Alert/n/n"; echo -e "The system was failed to update at $(date)") | ssmtp orwallla@gmail.com
			logger -s -i -t $0 -p user.info "The system was failed to update at $(date)" &>> /root/AutoAdmin/log/AutoAdmin.log
		fi
	fi

	sleep 10800
done
