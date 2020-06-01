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
pg_dumpall --globals-only > ${datename}_globals-only.sql

# Backup schema
pg_dumpall --schema-only > ${datename}_schema-only.sql

# Backup databases listed in file
for dbname in $(cat ${dblist})
do
        pg_dump -Fc -Z${compress} ${dbname} -f ${dstdir}/${dbname}_${datename}.sql.backup
done

