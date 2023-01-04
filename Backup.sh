#!/usr/bin/env bash
logger -s -i -t $0 -p user.info "Starting.." &>> /root/AutoAdmin/$(date +%d-%m-%y)-log.txt

#Core
backup () {
    for i in "${backup_directories[@]}"
    do
   	 sudo tar -zcf /tmp/backups/$i-$Date.tar.gz /$i > /dev/null 2>&1
   	 if [ $? -eq 0 ]
   	 then
   		 logger -s -i -t $0 -p user.info "/$i backup succeeded." &>> /root/AutoAdmin/$(date +%d-%m-%y)-log.txt
   	 else
   		 logger -s -i -t $0 -p user.info "/$i backup failed." &>> /root/AutoAdmin/$(date +%d-%m-%y)-log.txt
   	 fi

#Transfering
   	 if [ -z "$remoteServer" ] || [ -z "$remoteDirectory" ]
   	 then
   		 logger -s -i -t $0 -p user.info "No transfer configuration available, /$i not trasfered" &>> /root/AutoAdmin/$(date +%d-%m-%y)-log.txt
   	 else
   		 rsync /tmp/$i-$backup_date.tar.gz $userName@$dest_server:$dest_dir
   		 if [ $? -eq 0 ]; then
   			 logger -s -i -t $0 -p user.info "$i transfer succeeded." &>> /root/AutoAdmin/$(date +%d-%m-%y)-log.txt
   		 else
   			 logger -s -i -t $0 -p user.info "$i transfer failed." &>> /root/AutoAdmin/$(date +%d-%m-%y)-log.txt
   		 fi
   	 fi
    done
}
#Removing old backups
deleteoldbackup () {
    find /tmp/backups -type f ! -name "${backup_directories[0]}-$Date.tar.gz" ! -name "${backup_directories[1]}-$Date.tar.gz" -delete
    if [ $? -eq 1 ]
    then
   	 logger -s -i -t $0 -p user.info "Backup deletion error" &>> /root/AutoAdmin/$(date +%d-%m-%y)-log.txt
    fi
}



#Timing System
while true
do
#System Parameters
backup_directories=("home" "etc")
Date=$(date +%d-%m-%y)
remoteServer=""
remoteDirectory=""
userName=""
Mail="orwallla@gmail.com"
ls "/tmp/backups/${backup_directories[0]}-$Date.tar.gz" > /dev/null
#Condition for running
if [ $? -ne 0 ]
then
    mkdir -p /tmp/backups
    backup
    deleteoldbackup
    (echo "Subject: System_Backup_Alert"; echo "Backup was done at=$(date +%d-%m-%y)") | ssmtp $Mail
else
    logger -s -i -t $0 -p user.info "Tried to backup, up to date backup is available" &>> /root/AutoAdmin/$(date +%d-%m-%y)-log.txt
    sleep 10800
fi

done
