#!/usr/bin/env bash

logger -s -i -t $0 -p user.info "Starting.." &>> /root/AutoAdmin/log/AutoAdmin.log

function Dependencies()
{
	mkdir -p /root/AutoAdmin/log
	depenFiles=("Analytics.log" "Analytics.log.1" "Analytics.log.2" "Security.log" "Security.log.1" "Security.log.2" "AutoAdmin.log" "AutoAdmin.log.1" "AutoAdmin.log.2")
	for log in ${depenFiles[@]}
	do
		if [ ! -e /root/AutoAdmin/log/$log ]
		then
			touch /root/AutoAdmin/log/$log
		fi
	done
}

function Rotate()
{

	Mail=orwallla@gmail.com
	sysTime=$(date "+%s") #corrent system time
	logBirth=$(stat -c %W "/root/AutoAdmin/log/$1.log") # log creation time
	rTime=$(($sysTime-$logBirth))
	if [ $rTime -gt 86400 ]
	then 
		echo -e "Subject: System Logging" | (cat - && uuencode /root/AutoAdmin/log/$1.log $1.log) | ssmtp $Mail
		mv /root/AutoAdmin/log/$1.log.1 /root/AutoAdmin/log/$1.log.2 && mv /root/AutoAdmin/log/$1.log /root/AutoAdmin/log/$1.log.1
		rm /root/AutoAdmin/log/$1.log && touch /root/AutoAdmin/log/$1.log
	return 100
	fi
}

#Timing System

while true
do
	logger -s -i -t $0 -p user.info "Checking for dependencies" &>> /root/AutoAdmin/log/AutoAdmin.log
	Dependencies
	logger -s -i -t $0 -p user.info "Checking for rotation" &>> /root/AutoAdmin/log/AutoAdmin.log
	Rotate "Analytics"
	Rotate "Security"
	Rotate "AutoAdmin"
	if [ $? -eq 100 ]
	then
		logger -s -i -t $0 -p user.info "Rotate done." &>> /root/AutoAdmin/log/AutoAdmin.log
	fi

	sleep 3900
done
