#!/bin/bash
# Publish 1C bases to apache

database="database"
server="192.168.0.10"

/opt/1C/v8.3/x86_64/webinst -apache24 -wsdir ${database} -dir  /var/www/html/${database} -connstr "Srvr=${server};Ref=${database};" -confPath /etc/apache2/apache2.conf

systemctl restart apache2
