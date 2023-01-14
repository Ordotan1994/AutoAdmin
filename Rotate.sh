#!/usr/bin/env bash

logger -s -i -t $0 -p user.info "Starting.." &>> /root/AutoAdmin/log/AutoAdmin.txt


function Rotate()
{
	#System Parameters
	Mail=orwallla@gmail.com
	sysTime=date "+%s" #corrent system time
	logBirth=stat --format='%W' "$1" # log creation time

	if [ $(($sysTime-$logBirth)) > 86400 ]
	then 
		echo -e "Subject: System Logging" | (cat - && uuencode /root/AutoAdmin/log/$1.log $1.log) | ssmtp $Mail
		mv $1.log.1 $1.log.2 && mv $1.log $1.log.1
		rm $1.log && touch $1.log
}

#Timing System

while true
do
	logger -s -i -t $0 -p user.info "Starting The Collection" &>> /root/AutoAdmin/log/$(date +%d-%m-%y)-log.txt
	Rotate "Analytics"
	Rotate "Security"
	Rotate "AutoAdmin"
	logger -s -i -t $0 -p user.info "Starting The Collection" &>> /root/AutoAdmin/log/$(date +%d-%m-%y)-log.txt

	sleep 3600
done
