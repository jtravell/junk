#!/bin/bash
# configAide 
# configure file based intrusion detection - AIDE
 
/sbin/aide --init 
echo "aide has been initialized"
/bin/mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

echo "aide has been configured"
