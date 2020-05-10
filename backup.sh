#!/bin/bash
#BKPDIR="/mnt/net"
#DATEYMD=`date "+%Y-%m-%d-%a"` // а - указывает на день недели в формате Пн, Вт, Ср...пишет по русски?
#mkdir -p ${BKPDIR}/PostgreSQL 2>/dev/null // - можно не указывать, если предварительно создать директорию и выставить права.
#(pg_dump mydb <"${BKPDIR}/PostgreSQL/${DATEYMD}-mydb-PostgreSQL.gz"

#pg_dump -U postgres -Fc -Z9 dbname -f /mnt/net/Backup/Base/dbname.dump

#/usr/bin/pg_dump --file "/var/lib/pgadmin/storage/account/test.backup" --host "localhost" --port "5432" --username "postgres" --no-password --verbose --format=t --blobs "database"

# 50 18 * * * sh /home/scripts/backup.sh
