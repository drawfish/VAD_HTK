#/bin/bash
srchmm=$1
targethmm=$2
phonelab=$3
monophone=$4

source ../settings
source ../envconf

echo "Start HMM estimate :"`basename $targethmm`
rm -rf $targethmm
mkdir $targethmm
rm -rf $LOGDIR/HMMESTIMATE/`basename $targethmm`
mkdir -p $LOGDIR/HMMESTIMATE/`basename $targethmm`
rm -rf $ERRORDIR/HMMESTIMATE/`basename $targethmm`
mkdir -p $ERRORDIR/HMMESTIMATE/`basename $targethmm`
#Max number thread control
mkfifo tmpThread
exec 9<>tmpThread
for ((i=0;i<MAXTHREAD;i++))
do
	echo -ne '\n' 1>&9
done
parallelNum=0
for mfccpath in $MFCCPATH/*
do
	read -u 9
	parallelNum=$[$parallelNum+1]
	{
		tmp=`basename $mfccpath`
		mfcname=${tmp/.tmp/}
		label=$PHONEMLF/${mfcname//_/\/}/$phonelab
		$HTKTOOL/HERest -A -D -T 1 -C $CONFIGDIR/mfcc_cfg -H $srchmm/RMF.hmm -I $label \
						-t 250.0 150.0 1000.0 \
						-S $mfccpath -p $parallelNum \
						-M $targethmm $monophone \
						> $LOGDIR/HMMESTIMATE/`basename $targethmm`/`basename $mfccpath`.log \
						2> $ERRORDIR/HMMESTIMATE/`basename $targethmm`/`basename $mfccpath`.err
		echo -ne '\n' 1>&9
	} &
done
wait
parallelNum=0
$HTKTOOL/HERest -A -D -T 1 -C $CONFIGDIR/mfcc_cfg -H $srchmm/RMF.hmm \
				-t 250.0 150.0 1000.0 \
				-p $parallelNum -M $targethmm $monophone $targethmm/*.acc \
				> $LOGDIR/HMMESTIMATE/`basename $targethmm`/ACC.log \
				2> $ERRORDIR/HMMESTIMATE/`basename $targethmm`/ACC.err
rm $targethmm/*.acc
rm -rf tmpThread
#Delete the Error log if it's null;
sh $BASHSCRP/delnulllog.sh $LOGDIR/HMMESTIMATE/`basename $targethmm`
sh $BASHSCRP/delnulllog.sh $ERRORDIR/HMMESTIMATE/`basename $targethmm`
echo "Finish HMM estimate :"`basename $targethmm`
