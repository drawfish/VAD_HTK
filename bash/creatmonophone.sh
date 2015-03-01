#/bin/bash

targethmm=$1

source ../settings
source ../envconf

rm -rf $targethmm
rm -rf $LOGDIR/MONOPHONE
rm -rf $ERRORDIR/MONOPHONE
rm -rf $TMPDIR
mkdir -p $targethmm
mkdir $LOGDIR/MONOPHONE
mkdir $ERRORDIR/MONOPHONE
mkdir $TMPDIR

echo "Start building the monophone hmms!"
rm -rf $TMPDIR/trainmfccpath.tmp
for phonedir in $MFCCDIR/*
do
	for speaker in $phonedir/Wav/*
	do
		for mfc in $speaker/*
		do 
			if [ -e "$mfc" ];then
				echo $mfc >> $TMPDIR/trainmfccpath.tmp
			fi
		done
	done
done
$HTKTOOL/HCompV -A -D -T 1 -C $CONFIGDIR/mfcc_cfg \
						 -f 0.01 \
						 -m -S $TMPDIR/trainmfccpath.tmp \
						-M $targethmm $HMMPROTO/proto #\
						#	> $LOGDIR/MONOPHONE/HCOMPV.log 2>$ERRORDIR/MONOPHONE/HCOMPVERRO.err											 											
python $PYSCRP/creatmonophone.py $targethmm $MONOPHONEDIR/monophone0.ph
touch $TMPDIR/tmp.hed
$HTKTOOL/HHEd -H $targethmm/hmmdef -H $targethmm/macros -w $targethmm/RMF.hmm $TMPDIR/tmp.hed $MONOPHONEDIR/monophone0.ph \
>$LOGDIR/MONOPHONE/HHED.log 2>$ERRORDIR/MONOPHONE/HHEDERRO.err
 
rm $TMPDIR/tmp.hed
echo "Finish building the monophone hmms!" 