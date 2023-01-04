#!/usr/bin/env bash

logger -s -i -t $0 -p user.info "Starting.." &>> /root/AutoAdmin/log/$(date +%d-%m-%y)-log.txt

#Checking for log directory 
mkdir -p /root/AutoAdmin/log

#Deleting old log files
find /root/AutoAdmin/log -type f ! -name "$(date +%d-%m-%y)-log.txt" -delete
