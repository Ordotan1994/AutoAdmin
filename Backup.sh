#!/usr/bin/env bash
logger -s -i -t $0 -p user.info "Starting.." &>> /root/AutoAdmin/log/AutoAdmin.log

#Config file
source ./Auconfig.conf

#Core
function backup() {
    for i in "${backup_directories[@]}"
    do
   	 sudo tar -zcf /tmp/backups/$i-$Date.tar.gz --exclude-from="./White4Bak.txt" /$i > /dev/null 2>&1
   	 if [ $? -eq 0 ]
   	 then
   		 logger -s -i -t $0 -p user.info "/$i backup succeeded." &>> /root/AutoAdmin/log/AutoAdmin.log
   	 else
   		 logger -s -i -t $0 -p user.info "/$i backup failed." &>> /root/AutoAdmin/log/AutoAdmin.log
   	 fi

#Transfering
   	 if [ -z "$remoteServer" ] || [ -z "$remoteDirectory" ]
   	 then
   		 logger -s -i -t $0 -p user.info "No transfer configuration available, /$i not trasfered" &>> /root/AutoAdmin/log/AutoAdmin.log
   	 else
   		 rsync /tmp/$i-$backup_date.tar.gz $userName@$dest_server:$dest_dir
   		 if [ $? -eq 0 ]; then
   			 logger -s -i -t $0 -p user.info "$i transfer succeeded." &>> /root/AutoAdmin/log/AutoAdmin.log
   		 else
   			 logger -s -i -t $0 -p user.info "$i transfer failed." &>> /root/AutoAdmin/log/AutoAdmin.log
   		 fi
   	 fi
    done
}
#Removing old backups
function deleteoldbackup() {
    find /tmp/backups -type f ! -name "${backup_directories[0]}-$Date.tar.gz" ! -name "${backup_directories[1]}-$Date.tar.gz" -delete
    if [ $? -eq 1 ]
    then
   	 logger -s -i -t $0 -p user.info "Backup deletion error" &>> /root/AutoAdmin/log/AutoAdmin.log
    fi
}



#Timing System
while true
do

#System Parameters
Date=$(date +%d-%m-%y)

#Condition for running
ls "/tmp/backups/${backup_directories[0]}-$Date.tar.gz" &>> /dev/null
if [ $? -eq 0 ]
then
	logger -s -i -t $0 -p user.info "Tried to backup, up to date backup is available" &>> /root/AutoAdmin/log/AutoAdmin.log
	sleep 10800

else
	mkdir -p /tmp/backups
	deleteoldbackup
	backup
	(echo "Subject: System_Backup_Alert"; echo "Backup was done at=$(date +%d-%m-%y)") | ssmtp $Mail
	sleep 10800
fi
done
