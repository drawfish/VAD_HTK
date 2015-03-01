#/bin/bash
source ../settings
source ../envconf

echo "Start creat phone0 mlf!"
rm -rf $LOGDIR/PHONE0MLF
mkdir $LOGDIR/PHONE0MLF
rm -rf $ERRORDIR/PHONE0MLF
mkdir $ERRORDIR/PHONE0MLF

#Max number thread control
mkfifo tmpThread
exec 9<>tmpThread
for ((i=0;i<MAXTHREAD;i++))
do
	echo -ne '\n' 1>&9
done

if [ -d $PHONEMLF ];then
{
	for phonespfile in `find $PHONEMLF -name "phone0s.lab"`
	do
		rm -rf $phonespfile
	done 
}
else 
	mkdir -p $PHONEMLF
fi

for phonedirs in $WORDMLF/*
do 
	for speaker in $phonedirs/Wav/*
	do
		if [ -e $speaker/words.lab ];then
			read -u 9
		{
			phone0mlf=${speaker/$WORDMLF/$PHONEMLF}
			mkdir -p $phone0mlf
			$HTKTOOL/HLEd -d $DICT -i $phone0mlf/phone0s.lab $LED/mkphone0.led $speaker/words.lab \
			> $LOGDIR/PHONE0MLF/`basename $phone0mlf`.log \
			2>$ERRORDIR/PHONE0MLF/`basename $phone0mlf`.err
			echo -ne '\n' 1>&9
		} &
		fi
	done
done
wait 
rm -rf tmpThread
sh $BASHSCRP/delnulllog.sh $LOGDIR/PHONE0MLF
sh $BASHSCRP/delnulllog.sh $ERRORDIR/PHONE0MLF
echo "End creat phone0 mlf!"