#!/bin/bash

# Author: Ptantiku

TEST_URL='http://ifconfig.me/all'

echo -n "Input Proxy host:port (type 'exit' to exit) :>";
while read inputline
do

	if [ "$inputline" == "exit" ] || [ "$inputline" == "quit" ]; then
		exit
	else
		
		curl -p --socks5 $inputline $TEST_URL 2>/dev/null
		if [ $? -ne 0 ]; then
			curl -p --socks4 $inputline $TEST_URL 2>/dev/null
			if [ $? -ne 0 ]; then
				curl -p $inputline $TEST_URL 2>/dev/null
				if [ $? -ne 0 ]; then
					echo "PROXY $inputline IS NOT WORKING";
				else
					echo "[+] CONNECT TO HTTP PROXY $inputline SUCCEEDED";
				fi
			else
				echo "[+] CONNECT TO SOCKS4 PROXY $inputline SUCCEEDED";
			fi
		else
			echo "[+] CONNECT TO SOCKS5 PROXY $inputline SUCCEEDED";
			
		fi
	fi 
	
	echo -n "Input Proxy host:port (type 'exit' to exit) :>";
done
