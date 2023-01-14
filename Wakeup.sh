#!/usr/bin/env bash

logger -s -i -t $0 -p user.info "AutoAdmin in awake" &>> /root/AutoAdmin/log/AutoAdmin.log

#System Parameters
Date=$(date +%d-%m-%y)
Mail="orwallla@gmail.com"

#Core
(echo "Subject: System_wakeup_Alert"; echo -e "System in Up\nEndpoint=$(hostname)\nTime=$Date") | ssmtp $Mail

