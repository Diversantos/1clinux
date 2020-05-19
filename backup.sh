#!/bin/bash

SRCDIR="/mnt/snap"
DSTDIR="/home/backup"
BCKP_FILE="$DSTDIR/"`date "+%Y.%m.%d_%H-%M-%S"`

EXCLUSIONS="--exclude=proc --exclude=sys --exclude=dev/pts --exclude=backup --exclude=home//backup --exclude=home//video --exclude=tmp"

MYSQL_PID_FILE="/var/run/mysqld/mysqld.pid"
MYSQL_PID=`cat $MYSQL_PID_FILE`
MYSQL_D="/etc/init.d/mysqld"

VGROUP="/dev/vg_starsrv"
ROOT_LV="$VGROUP/lv_root"
MYSQL_LV="$VGROUP/lv_usr_db"
HOME_LV="$VGROUP/lv_home"
SNAP_LV="$VGROUP/lv_snap"

OWNERS="root:root"
NICE_PRIORITY=20

LOGDIR="/var/log/backup"
FLAGFILE="/var/run/check_backup.data"

###########################################################################
# Procedures

function chk_folder {
        if [ ! -d $1 ]; then
            mkdir -m 770 $1        || (echo "Can't create $1!"; exit 1)
            chown $OWNERS $1 >/dev/null
        fi
}
function umount_snap {
        echo "Unmount snapshot from $SRCDIR."
        umount $SRCDIR > /dev/null 2>&1 || (echo "Can't umount $SRCDIR!"; exit 1)
        echo "Delete LVM snapshot."
        lvm lvremove -f $SNAP_LV > /dev/null 2>&1 || (echo "Can't remove $SNAP_LV!"; exit 1)
}
function create_snap {
        if [ $2 -eq "mysql" ]; then
                echo "Stopping MysQL..."
                $MYSQL_D stop
                echo "stopped!"
                sleep 3
                echo "Check of mysql process."
                ps -p "$MYSQL_PID" 2>/dev/null | grep mysqld >/dev/null
                if [ "x$?" = "x0" ]; then
                  echo "Mysqld is still alive! So i'm out!"
                  exit 1
                fi
        fi
        echo "Create snapshoot of $1..."
        lvm lvcreate -l100%FREE -s -n lv_snap $1 || (echo "Can't create $1 snapshoot!"; exit 1)
        sleep 3
        lvm lvscan > /dev/null 2>&1
        echo "Mount snapshot to $SRCDIR"
        mount $SNAP_LV $SRCDIR || (echo "Can't mount $SRCDIR!"; exit 1)
        sleep 3
        if [ $2 -eq "mysql" ]; then
                echo "Starting MySQL..."
                $MYSQL_D start
                sleep 3
        fi
}
function create_arc {
        echo "Creating tar backup..."

        nice -n $NICE_PRIORITY tar -zcvpf "$BCKP_FILE-$1.tgz" $SRCDIR/* $EXCLUSIONS -C $DSTDIR > /dev/null 2>&1
        if [ "$?" != 0 ]; then
            exit 1
        fi
}

###########################################################################
# BODY

echo "Set flag-file for check in monitoring."
echo "Backup: Working | backup=1;" > $FLAGFILE

find $DSTDIR -type f -mtime +7 -delete

echo "Check some..."
chk_folder $SRCDIR
chk_folder $DSTDIR
chk_folder $LOGDIR
umount_snap


create_snap $ROOT_LV
create_arc "root"
umount_snap

create_snap $HOME_LV
create_arc "home"
umount_snap

nice -n $NICE_PRIORITY mysqldump -v -u backup -pBackup2020# --lock-tables --all-databases --add-drop-table --add-locks --create-options --single-transaction --disable-keys --extended-insert | gzip -c > "$BCKP_FILE.sql.gz"

echo "Fix permissions on backup."
chmod -R 660 $DSTDIR/*
chown -R $OWNERS $DSTDIR/*

rm -f $FLAGFILE>/dev/null
echo "End of backup!"
exit 0