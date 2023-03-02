# AutoAdmin

# Context
AutoAdmin is an automation suite written in bash, designed to automate sysadmin routine work for Linux distributions.

The program includes multiple utilities:

1. Automating system backups - The software will backup any user-defined files\folders on any user-defined scheduled time while managing the old backups, with automatic transfer to a remote server capability.  

2. Automating system updates - The software will use the system default package manager and apply updates on a user defined basis.  

3. Monitoring system resources - Valuable system parameters will be sampled every 5 seconds against the user definition to a threshold, if the parameters are exceeding the threshold mail will be sent to the user regarding this violation.  

4. Provide System Analytics - system analytics about crucial events will be gathered and sent on Real Time\scheduled bases, which will include: Errors, AUTH actions, SSH sessions, and any user defined keys.  

5. Log handling - the software will produce logs about the running scrips and actions and will rotate the logs along with the analytics and security logs.  
6. Uptime and Wakeup - the software will provide a Wakeup alert when the machine is turned in, and an uptime alert after running for more then 24 hours.  

# Config
the software uses 2 config files located at /etc/AutoAdmin/, and pre-configured to debian distributions.  
config.conf -  
in the config file, you will be able to turn off\on any one of the utilities and set up time intervals along with keywords for analytics, Email for notifications, directories to back up, the threshold for hardware usage alerts, etc..   
White4Bak.txt -  
in the White4Bak file, you will be able to exclude files from the automatic backups, any line without # sign will be excluded.  

# Dependencies
SSMTP - you will need ssmtp configured for system alerts, you can use this manual for installtion and setup - https://wiki.archlinux.org/title/SSMTP  
UUENCODE - The uuencode command converts a binary file to ASCII data. This is used to mail a file. Install "sharutils" package.  
RSYNC - you will need this package only if you want to send backups to remote server, it is not needed for local backups.  
TAR - Tar is a built-in tool on all the major Linux distros, you should have it installed.   
LOGGER - logger is a built-in tool on all the major Linux distros, you should have it installed.   

# Installation
The installtion file is called autoadmin.sh, and will install the software when activated.  
to install the software run the following commands:   
1. use git clone to download the reposetory   
2. cd to the software folder  
3. $ chmod +x autoadmin.sh  
4. $ sudo ./autoadmin.sh
5. Reboot the machine

# Uninstallation
The installtion file is called uninstall.sh, and will install the software when activated.  
to uninstall the software run the following commands:     
1. cd to the software folder  
2. $ chmod +x uninstall.sh  
3. $ sudo ./uninstall.sh  
4. Reboot the machine  

