#!/bin/bash
#####################################################################
# Testing vulnerability on Thai NTP(s) from using monlist attack    #
# Displaying table list of IP(s) means improper configured.         #
# Required: ntpdc (from "ntp" package)                              #
# Author: ptantiku                                                  #
#####################################################################

servers=( 
    ntp.ku.ac.th
    time.uni.net.th
    time.navy.mi.th
    time1.navy.mi.th
    time2.navy.mi.th
    time3.navy.mi.th
    clock.nectec.or.th
    time1.nimt.or.th
    time2.nimt.or.th
    time3.nimt.or.th
    fw.eng.ku.ac.th
    ilm.live.rmutt.ac.th
    itoml.live.rmutt.ac.th
    delta.cpe.ku.ac.th
    0.th.pool.ntp.org
    nucleus.nectec.or.th
    )
for s in ${servers[*]}
do
    echo "--$s--"
    timeout 5 ntpdc -c monlist $s
done
