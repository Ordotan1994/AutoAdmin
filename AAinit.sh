#!/usr/bin/env bash

logger -s -i -t $0 -p user.info "Starting.." &>> /var/log/AutoAdmin/AutoAdmin.log

#Config file
source /etc/AutoAdmin/config.conf

#Necessary Directories
mkdir -p /bin/AutoAdmin
mkdir -p /mnt/backups
mkdir -p /var/log/AutoAdmin
mkdir -p /etc/AutoAdmin

#Giving running permissions to the scripts
chown root /bin/AutoAdmin/*.sh
chmod +x /bin/AutoAdmin/*.sh

#Core
if [ $Analytics -eq 1 ]
then
	./Analytics.sh &
else
	logger -s -i -t $0 -p user.info "Analytics script is OFF" &>> /var/log/AutoAdmin/AutoAdmin.log
fi


if [ $Backup -eq 1 ]
then
        ./Backup.sh &
else
        logger -s -i -t $0 -p user.info "Backup script is OFF" &>> /var/log/AutoAdmin/AutoAdmin.log
fi


if [ $Monitoring_resource -eq 1 ]
then
        ./Monitoring_resource.sh &
else
        logger -s -i -t $0 -p user.info "Monitoring_resource script is OFF" &>> /var/log/AutoAdmin/AutoAdmin.log
fi


if [ $Rotate -eq 1 ]
then
        ./Rotate.sh &
else
        logger -s -i -t $0 -p user.info "Rotate script is OFF" &>> /var/log/AutoAdmin/AutoAdmin.log
fi


if [ $Update -eq 1 ]
then
        ./Update_auto.sh &
else
        logger -s -i -t $0 -p user.info "Update_auto script is OFF" &>> /var/log/AutoAdmin/AutoAdmin.log
fi


if [ $Uptime -eq 1 ]
then
        ./Uptime.sh &
else
        logger -s -i -t $0 -p user.info "Uptime script is OFF" &>> /var/log/AutoAdmin/AutoAdmin.log
fi


if [ $Wakeup -eq 1 ]
then
        ./Wakeup.sh &
else
        logger -s -i -t $0 -p user.info "Analytics script is OFF" &>> /var/log/AutoAdmin/AutoAdmin.log
fi


