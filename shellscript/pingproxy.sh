#!/bin/bash
# Author: Ptantiku
# This program enumerates through list of proxy(web and socks)
# in the input file, and perform ping test (count=3) on the proxy host
#

if [ $# -lt 1 ]; then
  echo "usage: pingproxy.sh proxylist"
  exit 1
else
  inputfile=$1
fi

for prox in $(cat $inputfile); do
   echo $prox
   host=$(echo -n $prox|cut -d: -f1)
   ping -c 3 $host | grep rtt
done

