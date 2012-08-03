#!/bin/bash
########################################
# Wait for a process to shutdown       #
# usage: ./waitforshutdown.sh <PID>    #
# developer: ptantiku                  #
########################################

PID = $1

while true
do
    if [ `ps aux | grep $PID | wc -l` -lt 2 ]
    then
        poweroff
    else
        echo "waiting for process PID/process name = '$PID' to shutdown"
    fi
    sleep 1
done

