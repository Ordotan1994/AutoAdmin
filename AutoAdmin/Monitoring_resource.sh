#!/bin/bash
logger -i -t $0 -p user.info "Starting.."
#System Parametars
cpuUsage=$(top -bn1 | awk '/Cpu/ {print $2}' | bc)
availDisk=$(df -h | awk '/dev/ {print $5}')
freeMemUsage=$(free -m | awk '/Mem/ {print $4}')
totalMem=$(free -m | awk '/Mem/ {print $2}')
memUsage=$(($freeMemUsage*100/$totalMem))
Mail="orwallla@gmail.com"

#Core

while true
do
	if [ "$(echo "$cpuUsage < 60" | bc)" -eq 1 ] || [ $memUsage -gt 80 ]
	then
		(echo "Subject: System_Resource_Alert"; echo -e "CpuUsage=$cpuUsage%\nMemUsage=$memUsage%\nTime=$(date)\nFrom=$(hostname)") | ssmtp $Mail
		logger -i -t $0 -p user.info "Alert was sent to $Mail, the resource status right now are CPU=$cpuUsage%,MEM=$memUsage%"
		sleep 120
	fi

	sleep 5
done
