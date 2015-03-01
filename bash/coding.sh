#/bin/bash
source ../settings
source ../envconf

rm -rf $ALLPATH
rm -rf $LOGDIR/CODING
mkdir $ALLPATH
mkdir $WAVPATH

#Max number thread control
mkfifo tmpThread
exec 9<>tmpThread
for ((i=0;i<$MAXTHREAD;i++))
do
	echo -ne '\n' 1>&9
done

echo "Start building the file system."
#Building the wav path
for phonedir in $WAVDIR/* 
do
	for speaker in $phonedir/Wav/*
	do
		if [ -d $speaker ];then
			read -u 9
			{
				tmp=${speaker/$WAVDIR\//}
				tmp=${tmp//\//_}
				f_wavpath=$WAVPATH/$tmp.tmp
				find $speaker -name *.wav > $f_wavpath
				echo -ne '\n' 1>&9
			} &
		fi
	done
done
wait
#Building the mfcc path file and scp path file
rm -rf $SCPPATH
rm -rf $MFCCPATH 
mkdir $SCPPATH
mkdir $MFCCPATH
for f_wavpath in $WAVPATH/*
do
	if [ -s $f_wavpath ];then
	read -u 9
	{
		tmp=`basename $f_wavpath`
		tmp=${tmp//\//_}
		f_mfccpath=$MFCCPATH/$tmp
		f_scppath=$SCPPATH/$tmp
		python $PYSCRP/creatscp.py  $f_wavpath $WAVDIR $MFCCDIR $f_scppath 
		echo -ne '\n' 1>&9
	} &
	fi
done
wait 
echo "Finish building the file system."
#Coding the wav to mfcc
:<<_b_
echo "Start coding!"
rm -rf $MFCCDIR
mkdir $MFCCDIR
mkdir $LOGDIR/CODING
mkdir $ERRORDIR/CODING
python $PYSCRP/creatmfcctree.py $WAVDIR $MFCCDIR
for f_scppath in $SCPPATH/*
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
_b_
#Rebuilding the mfcc path file 
echo "Rebuilding the mfcc path file."
rm -rf $MFCCPATH
mkdir $MFCCPATH
for phonedir in $MFCCDIR/*
do
	for speaker in $phonedir/Wav/*
	do
		if [ -d $speaker ];then
		read -u 9
		{
			for mfc in $speaker/*
			do 
				if [ -e "$mfc" ];then
					tmp=${mfc/$MFCCDIR\//}
					namebase=`basename $mfc`
					tmp=${tmp/\/$namebase/}
					tmp=${tmp//\//_}
					echo $mfc >> $MFCCPATH/$tmp.tmp
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
