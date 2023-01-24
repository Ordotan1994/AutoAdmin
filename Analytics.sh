#!/bin/bash
logger -s -i -t $0 -p user.info "Starting.." &>> /root/AutoAdmin/log/AutoAdmin.log

#Config file
source ./Auconfig.conf

#Core
function getLogs()
{
	while read line
	do 
		for KEY in "${@:4}"
		do
			if echo "$line" | grep -q "$(date "+%b %d")" && echo "$line" | grep -iq $KEY && ! echo "$line" | grep -Fq "$line" /root/AutoAdmin/log/$3.log
			then
				echo "$2 : $line" >> /root/AutoAdmin/log/$3.log
			fi
		done
	done < $1
}



#Timing System
while true
do
	logger -s -i -t $0 -p user.info "Starting The Collection" &>> /root/AutoAdmin/log/AutoAdmin.log
	getLogs "/var/log/syslog" "Syslog" "Analytics" "${Keys4Syslog[@]}"
	getLogs "/var/log/syslog" "secSyslog" "Security" "${Keys4secSyslog[@]}"
	getLogs "/var/log/auth.log" "Auth" "Security" "${Keys4Auth[@]}"
	getLogs "/var/log/kern.log" "Kern" "Analytics" "${Keys4Kern[@]}"
	getLogs "/var/log/boot.log" "Boot" "Analytics" "${Keys4Boot[@]}"
	logger -s -i -t $0 -p user.info "Collection ended" &>> /root/AutoAdmin/log/AutoAdmin.log

	sleep 600
done
