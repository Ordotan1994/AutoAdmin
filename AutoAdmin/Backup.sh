#!/bin/bash
logger -i -t $0 -p user.info "Starting.."

#Check for backup directory
checkfordir () {
    (ls /tmp | grep backups) >/dev/null
    if [ $? -eq 1 ]
    then
   	 mkdir /tmp/backups
    fi
}
#Core
backup () {
    for i in "${backup_directories[@]}"
    do
   	 sudo tar -zcvf /tmp/backups/$i-$Date.tar.gz /$i > /dev/null 2>&1
   	 if [ $? -eq 0 ]
   	 then
   		 logger -i -t $0 -p user.info "/$i backup succeeded."
   	 else
   		 logger -i -t $0 -p user.info "/$i backup failed."
   	 fi

#Transfering
   	 if [ -z "$remoteServer" ] || [ -z "$remoteDirectory" ]
   	 then
   		 logger -i -t $0 -p user.info "No transfer configuration available, /$i not trasfered"
   	 else
   		 scp /tmp/$i-$backup_date.tar.gz $dest_server:$dest_dir
   		 if [ $? -eq 0 ]; then
   			 logger -i -t $0 -p user.info "$i transfer succeeded."
   		 else
   			 logger -i -t $0 -p user.info "$i transfer failed."
   		 fi
   	 fi
    done
}
#Removing old backups
deleteoldbackup () {
    cd /tmp/backups
    if [ $? -eq 0 ]
    then
   	 find . -type f ! -name "${backup_directories[0]}-$Date.tar.gz" ! -name "${backup_directories[1]}-$Date.tar.gz" -delete
    else
   	 logger -i -t $0 -p user.info "Backup deletion error"
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
Mail="orwallla@gmail.com"
ls "/tmp/backups/${backup_directories[0]}-$Date.tar.gz" > /dev/null
#Condition for running
if [ $? -ne 0 ]
then
    checkfordir
    backup
    deleteoldbackup
    (echo "Subject: System_Backup_Alert"; echo "Backup was done at=$(date +%d-%m-%y)") | ssmtp $Mail
else
    logger -i -t $0 -p user.info "Tried to backup, up to date backup is available"
    sleep 10800
fi

done
