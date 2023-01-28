#!/usr/bin/env bash

logger -s -i -t $0 -p user.info "AutoAdmin in awake" &>> /var/log/AutoAdmin/AutoAdmin.log

#System Parameters
Mail="orwallla@gmail.com"

#Core
(echo -e "Subject: System_wakeup_Alert\n\n"; echo -e "System in Up\nEndpoint: $(hostname)\nTime: $(date)") | ssmtp $Mail

