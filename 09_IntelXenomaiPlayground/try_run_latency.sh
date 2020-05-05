#!/bin/bash

dmesg | grep -i Xenomai
cat /proc/xenomai/sched/threads

whoami
id -u root
id -G root

# Reference: https://www.mail-archive.com/xenomai@xenomai.org/msg11925.html
cat /sys/module/xenomai/parameters/allowed_group
ls -l /sys/module/xenomai/parameters/allowed_group 
chmod 744 /sys/module/xenomai/parameters/allowed_group
echo "0" >> /sys/module/xenomai/parameters/allowed_group
cat /sys/module/xenomai/parameters/allowed_group

# Reference: https://stackoverflow.com/questions/9313428/getting-eperm-when-calling-pthread-create-for-sched-fifo-thread-as-root-on-lin
ulimit -r unlimited

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/xenomai/lib
export PATH=$PATH:/usr/xenomai/bin

which latency
latency -p 1000
