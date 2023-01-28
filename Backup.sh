#!/usr/bin/env bash
logger -s -i -t $0 -p user.info "Starting.." &>> /var/log/AutoAdmin/AutoAdmin.log

#Config file
source /etc/AutoAdmin/config.conf

#Core
function backup() {
    for i in "${backup_directories[@]}"
    do
   	 sudo tar -zcf /mnt/backups/$i-$Date.tar.gz --exclude-from="/etc/AutoAdmin/White4Bak.txt" /$i > /dev/null 2>&1
   	 if [ $? -eq 0 ]
   	 then
   		 logger -s -i -t $0 -p user.info "/$i backup succeeded." &>> /var/log/AutoAdmin/AutoAdmin.log
   	 else
   		 logger -s -i -t $0 -p user.info "/$i backup failed." &>> /var/log/AutoAdmin/AutoAdmin.log
   	 fi

#Transfering
   	 if [ -z "$remoteServer" ] || [ -z "$remoteDirectory" ]
   	 then
   		 logger -s -i -t $0 -p user.info "No transfer configuration available, /$i not trasfered" &>> /var/log/AutoAdmin/AutoAdmin.log
   	 else
   		 rsync /tmp/$i-$backup_date.tar.gz $userName@$dest_server:$dest_dir
   		 if [ $? -eq 0 ]; then
   			 logger -s -i -t $0 -p user.info "$i transfer succeeded." &>> /var/log/AutoAdmin/AutoAdmin.log
   		 else
   			 logger -s -i -t $0 -p user.info "$i transfer failed." &>> /var/log/AutoAdmin/AutoAdmin.log
   		 fi
   	 fi
    done
}
#Removing old backups
function deleteoldbackup() {
    find /mnt/backups -type f ! -name "${backup_directories[0]}-$Date.tar.gz" ! -name "${backup_directories[1]}-$Date.tar.gz" -delete
    if [ $? -eq 1 ]
    then
   	 logger -s -i -t $0 -p user.info "Backup deletion error" &>> /var/log/AutoAdmin/AutoAdmin.log
    fi
}



#Timing System
while true
do

#System Parameters
Date=$(date +%d-%m-%y)

#Condition for running
ls "/mnt/backups/${backup_directories[0]}-$Date.tar.gz" &>> /dev/null
if [ $? -eq 0 ]
then
	logger -s -i -t $0 -p user.info "Tried to backup, up to date backup is available" &>> /var/log/AutoAdmin/AutoAdmin.log
	sleep 10800

else
	mkdir -p /mnt/backups
	deleteoldbackup
	backup
	(echo "Subject: System_Backup_Alert"; echo "Backup was done at=$(date +%d-%m-%y)") | ssmtp $Mail
	sleep 10800
fi
done
