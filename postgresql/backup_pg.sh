#!/bin/bash

datename=`date +%Y%m%d%H%M`
bindir="/opt/pgpro/1c-12/bin"
dstdir="/var/lib/pgadmin/storage/boo"
dblist="/var/lib/postgresql/scripts/db.txt"
tmpdir="/mnt/tmpbackup"

server="localhost"
port="5432"
username="postgres"
compress=7

cd ${bindir}

echo "Stop Yandex disk..."
/usr/bin/yandex-disk stop

# Backup globals
echo "Backuping Globals..."
pg_dumpall --globals-only -f ${tmpdir}/${datename}_globals-only.sql
mv ${tmpdir}/${datename}_globals-only.sql ${dstdir}/${datename}_globals-only.sql
sleep 10

# Backup schema
echo "Backuping SCHEMA..."
pg_dumpall --schema-only -f ${tmpdir}/${datename}_schema-only.sql
mv ${tmpdir}/${datename}_schema-only.sql ${dstdir}/${datename}_schema-only.sql
sleep 10

# Backup databases listed in file
for dbname in $(cat ${dblist})
do
	echo "Backuping ${dbname}..."
        pg_dump -Fc -Z${compress} ${dbname} -f ${tmpdir}/${dbname}_${datename}.sql.backup
        mv ${tmpdir}/${dbname}_${datename}.sql.backup ${dstdir}/${dbname}_${datename}.sql.backup
	sleep 10
done

echo "Start Yandex disk..."
/usr/bin/yandex-disk start
