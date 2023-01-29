#!/usr/bin/env bash

# Copyright (c) 2023 Or Dotan - https://github.com/Ordotan1994/AutoAdmin

logger -s -i -t $0 -p user.info "AutoAdmin in awake" &>> /var/log/AutoAdmin/AutoAdmin.log

#Config file
source /etc/AutoAdmin/config.conf

#Core
(echo -e "Subject: System_wakeup_Alert\n\n"; echo -e "System in Up\nEndpoint: $(hostname)\nTime: $(date)") | ssmtp $Mail

