#/bin/bash

source ../settings
source ../envconf
echo "Start create sp label mlf!"
rm -rf $LOGDIR/SPMLF
mkdir -p $LOGDIR/SPMLF
rm -rf $ERRORDIR/SPMLF
mkdir -p $ERRORDIR/SPMLF

#Max number thread control
mkfifo tmpThread
exec 9<>tmpThread
for ((i=0;i<MAXTHREAD;i++))
do
	echo -ne '\n' 1>&9
done 

for phonespfile in `find $PHONEMLF -name "phonesp.lab"`
do
	rm -rf $phonespfile
done 
for phonedirs in $WORDMLF/*
do
	for speaker in $phonedirs/Wav/*
	do
		read -u 9
	{
		$HTKTOOL/HLEd -A -D -T 1 -d $DICTSPSIL \
					-i ${speaker/$WORDMLF/$PHONEMLF}/phonesp.lab \
					$LED/mkphonesp.led $speaker/words.lab \
					> $LOGDIR/SPMLF/HLED.log 2>$ERRORDIR/SPMLF/HLED.log
		echo -ne '\n' 1>&9 
	}&
	done 
done 
wait
sh $BASHSCRP/delnulllog.sh $LOGDIR/SPMLF
sh $BASHSCRP/delnulllog.sh $ERRORDIR/SPMLF
rm tmpThread
echo "Finish create sp label mlf!"