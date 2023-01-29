#!/usr/bin/env bash
logger -s -i -t $0 -p user.info "Starting.." &>> /var/log/AutoAdmin/AutoAdmin.log

#Config file
source /etc/AutoAdmin/config.conf

#System Parametars
cpuUsage=$(top -bn1 | awk '/Cpu/ {print $2}' | bc)
availDisk=$(df -h | awk '/dev/ {print $5}')
availMem=$(free -m | awk '/Mem/ {print $7}')
totalMem=$(free -m | awk '/Mem/ {print $2}')
freeMem=$(($availMem*100/$totalMem))

#Core

while true
do
	if [ "$(echo "$cpuUsage > $cpuPrecent" | bc)" -eq 1 ] || [ $freeMem -lt $memPrecent ]
	then
		(echo "Subject: System_Resource_Alert"; echo -e "CpuUsage=$cpuUsage%\nFreeMem=$freeMem%\nTime=$(date)\nFrom=$(hostname)") | ssmtp $Mail
		logger -s -i -t $0 -p user.info "Alert was sent to $Mail, the resource status right now are CPU=$cpuUsage%,FreeMem=$freeMem%" &>> /var/log/AutoAdmin/AutoAdmin.log
		sleep 60
	fi

	#sleep 5
	sleep 500
done
