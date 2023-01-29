#!/usr/bin/env bash

# Copyright (c) 2023 Or Dotan - https://github.com/Ordotan1994/AutoAdmin

logger -s -i -t $0 -p user.info "Starting.." &>> /var/log/AutoAdmin/AutoAdmin.log

#Config file
source /etc/AutoAdmin/config.conf

while true
do
#System Parametars
	lastUpdate="$(stat -c %Y '/var/cache/apt')"
	sysDate="$(date +'%s')"
	interval=$(($sysDate - $lastUpdate))
#core
	if [ $interval -gt $updateInterval ]
	then
		$PKG update && $PKG upgrade -y
		if [ $? -eq 0 ]
		then
			(echo -e "Subject: System_Update_Alert\n\n"; echo -e "The system was fully updated at $(date)") | ssmtp $Mail
			logger -s -i -t $0 -p user.info "The system was fully updated at $(date)" &>> /var/log/AutoAdmin/AutoAdmin.log
		else
			(echo -e "Subject: System_Update_Alert/n/n"; echo -e "The system was failed to update at $(date)") | ssmtp $Mail
			logger -s -i -t $0 -p user.info "The system was failed to update at $(date)" &>> /var/log/AutoAdmin/AutoAdmin.log
		fi
	fi

	sleep 10800
done
