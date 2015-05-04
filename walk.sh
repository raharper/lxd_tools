#!/bin/bash
START=${1-0}
END=${2-1000}
PAR=${3-20}
LOGDIR=/tmp

# stop a free < $MIN_FREE 
MIN_FREE=${1:-"524288"}  # 512MB

spawn() {
   set -e
   name=${1}
   date +%s;
   FREE=$(free | awk '/Mem:/ {print $4}')
   [ ${FREE} -lt ${MIN_FREE} ] && { echo "Low Ram, exiting"; return 1; }
   sudo ./create_pylxd_overlay $name vivid-template/rootfs
   date +%s;
}


date +%s;
for v in $(seq -w $START $END); do
    PIDS=""
    for i in $(seq $PAR); do
        spawn $v 2>&1 | tee $LOGDIR/lxc-${v}.out &
        PIDS="$PIDS $!"
    done
    for pid in $PIDS; do
        wait $pid
    done
done;
date +%s
