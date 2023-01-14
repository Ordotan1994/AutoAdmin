#!/bin/bash
#set -eux
logger -s -i -t $0 -p user.info "Starting.." &>> /root/AutoAdmin/log/$(date +%d-%m-%y)-log.txt

#Creating log file
if [ ! -e /root/AutoAdmin/log/$(date +%d-%m-%y)-AnaliticsLog.txt ]
then
	touch /root/AutoAdmin/log/$(date +%d-%m-%y)-AnaliticsLog.txt
fi

#Core
function getLogs()
{
	while read line
	do 
		for KEY in "${@:3}"
		do
			if echo "$line" | grep -q "$(date "+%b %d")" && echo "$line" | grep -iq $KEY && ! echo "$line" | grep -Fq "$line" /root/AutoAdmin/log/$(date +%d-%m-%y)-AnaliticsLog.txt
			then
				echo "$2 : $line" >> /root/AutoAdmin/log/$(date +%d-%m-%y)-AnaliticsLog.txt
			fi
		done
	done < $1
}


#System Parameters
Keys4Syslog=("failed" "error")
Keys4Auth=("authentication" "incorrect" "remove" "delete")
Keys4Kern=("EMERG" "ALERT" "CRIT")
Keys4Boot=("DEPEND" "failed")

#Timing System
while true
do
	logger -s -i -t $0 -p user.info "Starting The Collection" &>> /root/AutoAdmin/log/$(date +%d-%m-%y)-log.txt
	getLogs "/var/log/syslog" "Syslog" "${Keys4Syslog[@]}"
	getLogs "/var/log/auth.log" "Auth" "${Keys4Auth[@]}"
	getLogs "/var/log/kern.log" "Kern" "${Keys4Kern[@]}"
	getLogs "/var/log/boot.log" "Boot" "${Keys4Boot[@]}"
	logger -s -i -t $0 -p user.info "Collection ended" &>> /root/AutoAdmin/log/$(date +%d-%m-%y)-log.txt

	echo "123"

	sleep 600
done
