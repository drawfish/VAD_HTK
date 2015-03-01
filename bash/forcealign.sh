#/bin/bash
srchmm=$1
labname=$2
monophonename=$3

source ../settings
source ../envconf

echo "Start force alignment: "`basename $srchmm`
rm -rf $LOGDIR/FORCEALIGN/`basename $srchmm`
mkdir -p $LOGDIR/FORCEALIGN/`basename $srchmm`
rm -rf $ERRORDIR/FORCEALIGN/`basename $srchmm`
mkdir -p $ERRORDIR/FORCEALIGN/`basename $srchmm`
#Max number thread control
mkfifo tmpThread
exec 9<>tmpThread
for ((i=0;i<$MAXTHREAD;i++))
do
	echo -ne '\n' 1>&9
done

for phonespfile in `find $PHONEMLF -name $labname `
do
	rm -rf $phonespfile
done 

for mfccpaths in $MFCCPATH/*
do 
	read -u 9
{
	tmp=`basename $mfccpaths`
	tmp=${tmp/.tmp/}
	alignphonedir=$PHONEMLF/${tmp//_/\/}
	worddir=$WORDMLF/${tmp//_/\/}
	tmplabname=tmp_$labname
	$HTKTOOL/HVite -T 1 -o SWT -b silence -C $CONFIGDIR/mfcc_cfg -a -H $srchmm/RMF.hmm \
					-i $alignphonedir/$tmplabname -m -t 250.0 -y lab -I $worddir/words.lab \
					-S $mfccpaths $DICTSPSIL $MONOPHONEDIR/$monophonename \
					>$LOGDIR/FORCEALIGN/`basename $srchmm`/HVITE_$tmp.log \
					2>$ERRORDIR/FORCEALIGN/`basename $srchmm`/HVITE_$tmp.err
	$HTKTOOL/HLEd -A -D -T 1 -i $alignphonedir/$labname $LED/mkalignfix.led $alignphonedir/$tmplabname \
					>$LOGDIR/FORCEALIGN/`basename $srchmm`/HLED_$tmp.log \
					2>$ERRORDIR/FORCEALIGN/`basename $srchmm`/HLED_$tmp.err
	rm $alignphonedir/$tmplabname
	if [ $? -eq 0 ]
	then
		python $PYSCRP/alignupdatemfcc.py $LOGDIR/FORCEALIGN/`basename $srchmm`/HVITE_$tmp.log \
										 $mfccpaths
	fi
	echo -ne '\n' 1>&9 
} &
done 
wait
sh $BASHSCRP/delnulllog.sh $LOGDIR/FORCEALIGN/`basename $srchmm`
sh $BASHSCRP/delnulllog.sh $ERRORDIR/FORCEALIGN/`basename $srchmm`
rm -rf tmpThread
echo "Finish force alignment: "`basename $srchmm`