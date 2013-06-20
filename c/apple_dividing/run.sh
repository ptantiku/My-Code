#!/bin/bash

if [ $# -eq 0 ]
then
	echo "usage: $0 PROGRAM_NAME"
	echo "example: $0 a"
	exit
else
	prog=$1
fi

gcc -o ./$prog ./$prog.c -lm

if [ $? -ne 0 ]
then
	echo "compiling failed"
	exit 
else
	echo "compiling succeeded: ./$prog"
fi

i=1
while read line
do
	echo -n "case #$i: ./$prog $line"
	time ./$prog $line # > /dev/null
	i=`expr $i + 1`
done < cases.txt
