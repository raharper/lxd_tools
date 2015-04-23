#!/bin/bash

# stop a free < $MIN_FREE 
MIN_FREE=${1:-"524288"}  # 512MB

date +%s;
for v in $(seq -w 0 1000); do
    sudo ./create_pylxd_overlay $v || break
    date +%s;
    FREE=$(free | awk '/Mem:/ {print $4}')
    [ ${FREE} -lt ${MIN_FREE} ] && { echo "Low Ram, exiting"; break; }
done;
date +%s
