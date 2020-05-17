#!/bin/bash
disk=/dev/sdh
logs=test.log

#Drop caches
sync
echo 1 > /proc/sys/vm/drop_caches

echo "### IOps test"
#fio -readonly -name iops -rw=randread -bs=512 -runtime=20 -iodepth 32 -filename $disk -ioengine libaio -direct=1

echo "### Linear write test"
#dd if=/dev/urandom of=$disk bs=128M oflag=direct

echo "### Memory test for 2-channel memory"
#for test in {1..18}; do ramsmp -b $test -r -g 2 | grep -v RAMspeed | grep -v "per pass mode"; done |  tee $logs

