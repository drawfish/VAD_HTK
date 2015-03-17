#/bin/bash
source ../settings
source ../envconf
:<<_a_
rm -rf $TESTPATH
rm -rf $LOGDIR/CODING
mkdir $TESTPATH
mkdir $TESTWAVPATH
#Max number thread control
mkfifo tmpThread
exec 9<>tmpThread
for ((i=0;i<$MAXTHREAD;i++))
do
	echo -ne '\n' 1>&9
done

echo "Start building the file system."
#Building the wav path
for phonedir in $TESTWAVDIR/* 
do
	for speaker in $phonedir/*
	do
		if [ -d $speaker ];then
			read -u 9
			{
				tmp=${speaker/$TESTWAVDIR\//}
				tmp=${tmp//\//_}
				f_wavpath=$TESTWAVPATH/$tmp.tmp
				find $speaker -name *.wav > $f_wavpath
				echo -ne '\n' 1>&9
			} &
		fi
	done
done
wait
#Building the mfcc path file and scp path file
rm -rf $TESTSCPPATH
rm -rf $TESTMFCCPATH 
mkdir $TESTSCPPATH
mkdir $TESTMFCCPATH
for f_wavpath in $TESTWAVPATH/*
do
	if [ -s $f_wavpath ];then
	read -u 9
	{
		tmp=`basename $f_wavpath`
		tmp=${tmp//\//_}
		f_mfccpath=$TESTMFCCPATH/$tmp
		f_scppath=$TESTSCPPATH/$tmp
		python $PYSCRP/creatscp.py  $f_wavpath $TESTWAVDIR $TESTMFCCDIR $f_scppath 
		echo -ne '\n' 1>&9
	} &
	fi
done
wait 
echo "Finish building the file system."
#Coding the wav to mfcc
echo "Start coding!"
rm -rf $TESTMFCCDIR
mkdir $TESTMFCCDIR
mkdir $LOGDIR/CODING
mkdir $ERRORDIR/CODING
python $PYSCRP/creatmfcctree.py $TESTWAVDIR $TESTMFCCDIR
for f_scppath in $TESTSCPPATH/*
do
	if [ -s $f_scppath ];then
	read -u 9
	tmp=`basename $f_scppath`
	tmp=${tmp//\//_}
	{
		$HTKTOOL/HCopy -A -D -T 1 -C $CONFIGDIR/mfcc_cfg -C $CONFIGDIR/wavfile_cfg -S $f_scppath \
		> $LOGDIR/CODING/HCOPY_$tmp.log 2>$ERRORDIR/CODING/HCOPY_$tmp.err
		echo -ne '\n' 1>&9
	} &
	fi
done
wait
#Rebuilding the mfcc path file 
echo "Rebuilding the mfcc path file."
rm -rf $TESTMFCCPATH
mkdir $TESTMFCCPATH
for phonedir in $TESTMFCCDIR/*
do
	for speaker in $phonedir/*
	do
		if [ -d $speaker ];then
		read -u 9
		{
			for mfc in $speaker/*
			do 
				if [ -e "$mfc" ];then
					tmp=${mfc/$TESTMFCCDIR\//}
					namebase=`basename $mfc`
					tmp=${tmp/\/$namebase/}
					tmp=${tmp//\//_}
					echo $mfc >> $TESTMFCCPATH/$tmp.tmp
				fi
			done
			echo '\n' 1>&9
		} & 
		fi
	done
done
wait
echo "Finish rebuilding the mfcc path file."
sh $BASHSCRP/delnulllog.sh $LOGDIR/CODING
sh $BASHSCRP/delnulllog.sh $ERRORDIR/CODING
rm tmpThread
echo "End coding!"
_a_
echo "Generate word network."
$HTKTOOL/HParse $TESTNETDIR/Gram.net $TESTNETDIR/wdnet.net
echo "Finish generate."
echo "Start recognize."
rm -rf $TESTRESULT
mkdir $TESTRESULT
for mfccpaths in $TESTMFCCPATH/*
do 
	result=$TESTRESULT/`basename $mfccpaths`
	$HTKTOOL/HVite -H $HMMDIR/hmm13/RMF.hmm -S $mfccpaths \
	-i $result -w $TESTNETDIR/wdnet.net \
	-p 0.0 -s 5.0 $TESTDICT/test.dic $TESTLIST/phonelist.ph
done
echo "Finish recognize."