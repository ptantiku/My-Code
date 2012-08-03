#!/bin/bash

###########################################################################
# Enable middle click mouse for Logitech mouse without middle click       #
# usage: ./enableMiddleClick.sh                                           #
# developer: ptantiku                                                     #
###########################################################################

for i in $(xinput list | grep Logitech | grep pointer | cut -d'=' -f 2 | cut -f 1)
do
	# xinput set-prop $(xinput list | grep Logitech | grep pointer | cut -d'=' -f 2 | cut -f 1) 252 1
	middleclickprop=`xinput list-props $i | grep 'Middle Button Emulation' | sed 's/.*(\([0-9]*\)).*/\1/'`
	xinput set-prop $i $middleclickprop 1
done

# set numlock on
numlockx on
