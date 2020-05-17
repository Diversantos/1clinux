#!/bin/bash

# hdparm --user-master u --security-set-pass pass /dev/sda
hdparm -I /dev/sda
# time hdparm --user-master u --security-erase pass /dev/sda

# hdparm --security-disable pass
