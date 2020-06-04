#!/bin/bash

datename=`date +%Y%m%d%H%M`
bindir="/opt/pgpro/1c-12/bin/psql"
dstdir="/var/lib/pgadmin/storage"
dblist="/var/lib/postgresql/scripts/db.txt"

server="localhost"
port="5432"
username="postgres"
compress=7

cd ${bindir}

# Backup globals
echo "Backuping Globals..."
pg_dumpall --globals-only -f ${dstdir}/${datename}_globals-only.sql

# Backup schema
echo "Backuping SCHEMA..."
#pg_dumpall --schema-only -f ${dstdir}/${datename}_schema-only.sql

# Backup databases listed in file
for dbname in $(cat ${dblist})
do
	echo "Backuping ${dbname}..."
        #pg_dump -Fc -Z${compress} ${dbname} -f ${dstdir}/${dbname}_${datename}.sql.backup
done

