#!/usr/bin/env bash

# Copyright (c) 2023 Or Dotan - https://github.com/Ordotan1994/AutoAdmin

logger -s -i -t $0 -p user.info "Starting.." &>> /var/log/AutoAdmin/AutoAdmin.log

#Config file
source /etc/AutoAdmin/config.conf

function Dependencies()
{
	mkdir -p /var/log/AutoAdmin
	depenFiles=("Analytics.log" "Analytics.log.1" "Analytics.log.2" "Security.log" "Security.log.1" "Security.log.2" "AutoAdmin.log" "AutoAdmin.log.1" "AutoAdmin.log.2")
	for log in ${depenFiles[@]}
	do
		if [ ! -e /var/log/AutoAdmin/$log ]
		then
			touch /var/log/AutoAdmin/$log
		fi
	done
}

function Rotate()
{

	sysTime=$(date "+%s") #corrent system time
	logBirth=$(stat -c %W "/var/log/AutoAdmin/$1.log") # log creation time
	rTime=$(($sysTime-$logBirth))
	if [ $rTime -gt $rotateInterval ]
	then
		echo -e "Subject: System Logging" | (cat - && uuencode /var/log/AutoAdmin/$1.log $1.log) | ssmtp $Mail
		mv /var/log/AutoAdmin/$1.log.1 /var/log/AutoAdmin/$1.log.2 && mv /var/log/AutoAdmin/$1.log /var/log/AutoAdmin/$1.log.1
		rm /var/log/AutoAdmin/$1.log && touch /var/log/AutoAdmin/$1.log
	return 100
	fi
}

#Timing System

while true
do
	logger -s -i -t $0 -p user.info "Checking for dependencies" &>> /var/log/AutoAdmin/AutoAdmin.log
	Dependencies
	logger -s -i -t $0 -p user.info "Checking for rotation" &>> /var/log/AutoAdmin/AutoAdmin.log
	Rotate "Analytics"
	Rotate "Security"
	Rotate "AutoAdmin"
	if [ $? -eq 100 ]
	then
		logger -s -i -t $0 -p user.info "Rotate done." &>> /var/log/AutoAdmin/AutoAdmin.log
	fi

	sleep 3900
done
