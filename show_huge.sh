#!/bin/bash
cat /proc/meminfo | grep -i huge
echo " "
pid=`head -1 /var/lib/pgpro/1c-12/data/postmaster.pid`
echo "Pid:            $pid"
peak=`grep ^VmPeak /proc/$pid/status | awk '{ print $2 }'`
echo "VmPeak:            $peak kB"
hps=`grep ^Hugepagesize /proc/meminfo | awk '{ print $2 }'`
echo "Hugepagesize:   $hps kB"
hp=$((peak/hps))
echo Set Huge Pages:     $hp
