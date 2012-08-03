#!/bin/bash

## check for root only ##
if [ $EUID = 0 ]; then
	"$@"
else
	gksu
fi

## PARAMETERS ##
IN_INT="eth0"
EX_INT="wlan1"

ifconfig $IN_INT 192.168.1.1 netmask 255.255.255.0
 
## enable forwarding ##
echo 1 > /proc/sys/net/ipv4/ip_forward
 
## for NAT $IN_INT ----> EX_INT (internet) ##
/sbin/iptables -F              #clear all routing
/sbin/iptables -t nat -F	#clear all routing in nat table
/sbin/iptables -t nat -A POSTROUTING -o $EX_INT -j MASQUERADE
/sbin/iptables -A FORWARD -i $EX_INT -o $IN_INT -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A FORWARD -i $IN_INT -o $EX_INT -j ACCEPT

