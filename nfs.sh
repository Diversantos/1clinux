#!/bin/bash

#tune2fs -m 2 /dev/sdd

apt-get update
apt install nfs-kernel-server
mkdir -p /mnt/backups
chown nobody:nogroup /mnt/backups
chmod 777 /mnt/backups
echo "/mnt/backups 192.168.0.1(rw,sync,no_subtree_check)" >> /etc/exports
echo "/mnt/backups 192.168.0.2(rw,sync,no_subtree_check)" >> /etc/exports
echo "/mnt/backups 192.168.0.3(rw,sync,no_subtree_check)" >> /etc/exports
exportfs -a
systemctl restart nfs-kernel-server

#ufw allow from [clientIP or clientSubnetIP] to any port nfs
#ufw allow from 192.168.0.0/24 to any port nfs

########### Client
apt-get update
apt-get install nfs-common
mkdir -p /mnt/sharedfolder_client
mount serverIP:/exportFolder_server /mnt/mountfolder_client
mount 192.168.0.1:/mnt/sharedfolder /mnt/sharedfolder_client

