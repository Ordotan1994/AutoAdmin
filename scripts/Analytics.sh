#!/bin/bash
logger -s -i -t $0 -p user.info "Starting.." &>> /var/log/AutoAdmin/AutoAdmin.log

#Config file
source /etc/AutoAdmin/config.conf

#Core
function getLogs()
{
	while read line
	do
		for KEY in "${@:4}"
		do
			if echo "$line" | grep -q "$(date "+%b %d")" && echo "$line" | grep -wiq $KEY
			then
				if ! grep -Fq "$line" /var/log/AutoAdmin/$3.log
				then
					echo "$2 : $line" >> /var/log/AutoAdmin/$3.log
				fi
			fi
		done
	done < $1
}



#Timing System
while true
do
	logger -s -i -t $0 -p user.info "Starting The Collection" &>> /var/log/AutoAdmin/AutoAdmin.log
	getLogs "/var/log/syslog" "Syslog" "Analytics" "${Keys4Syslog[@]}"
	getLogs "/var/log/syslog" "secSyslog" "Security" "${Keys4secSyslog[@]}"
	getLogs "/var/log/auth.log" "Auth" "Security" "${Keys4Auth[@]}"
	getLogs "/var/log/kern.log" "Kern" "Analytics" "${Keys4Kern[@]}"
	getLogs "/var/log/boot.log" "Boot" "Analytics" "${Keys4Boot[@]}"
	logger -s -i -t $0 -p user.info "Collection ended" &>> /var/log/AutoAdmin/AutoAdmin.log


	sleep 3600
done
