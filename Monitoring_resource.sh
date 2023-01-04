#!/usr/bin/env bash
logger -i -t $0 -p user.info "Starting.." &>> /root/AutoAdmin/log/$(date +%d-%m-%y)-log.txt
#System Parametars
cpuUsage=$(top -bn1 | awk '/Cpu/ {print $2}' | bc)
availDisk=$(df -h | awk '/dev/ {print $5}')
availMemUsage=$(free -m | awk '/Mem/ {print $7}')
totalMem=$(free -m | awk '/Mem/ {print $2}')
memUsage=$(($availMemUsage*100/$totalMem))
Mail="orwallla@gmail.com"

#Core

while true
do
	if [ "$(echo "$cpuUsage > 60" | bc)" -eq 1 ] || [ $memUsage -lt 20 ]
	then
		(echo "Subject: System_Resource_Alert"; echo -e "CpuUsage=$cpuUsage%\nMemUsage=$memUsage%\nTime=$(date)\nFrom=$(hostname)") | ssmtp $Mail
		logger -s -i -t $0 -p user.info "Alert was sent to $Mail, the resource status right now are CPU=$cpuUsage%,MEM=$memUsage%" &>> /root/AutoAdmin/log/$(date +%d-%m-%y)-log.txt
		sleep 600
	fi

	sleep 5
done
