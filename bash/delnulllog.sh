#/bin/bash
logdir=$1

source ../settings
source ../envconf

#Delete the Error log if it's null;
for log in $logdir/*
do
	if [ ! -s $log ];then
		rm $log
	fi
done