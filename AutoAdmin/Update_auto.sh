#!/bin/bash
logger -i -t $0 -p user.info "Starting.."

while true
do
#System Parametars
	lastUpdate="$(stat -c %Y '/var/cache/apt')"
	sysDate="$(date +'%s')"
	interval=$(($sysDate - $lastUpdate))
#core
	if [ $interval -lt 43200 ]
	then
		apt update && apt full-upgrade -y
		if [ $? -eq 0 ]
		then
			(echo "Subject: System_Update_Alert"; echo "The system was fully updated at unix time=$sysDate") | ssmtp orwallla@gmail.com
			logger -i -t $0 -p user.info "The system was fully updated at unix time=$sysDate"
		else
			(echo "Subject: System_Update_Alert"; echo "The system was failed to update at unix time=$sysDate") | ssmtp orwallla@gmail.com
			logger -i -t $0 -p user.info "The system was failed to update at unix time=$sysDate"
		fi
	fi

	sleep 10800
done
