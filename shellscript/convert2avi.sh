#!/bin/bash
# convert2avi.sh for converting any vdo file into AVI(+MP3 audio) format
# usage: convert2avi.sh inputfile outputfile
# developer: ptantiku

if [ $# -ne 2 ]
then
	echo "usage: convert2avi.sh inputfile outputfile"
	exit 0
else
	echo "Pass"
	mencoder $1 -o $2 -ovc lavc -oac mp3lame
fi
