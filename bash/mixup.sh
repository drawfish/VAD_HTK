#/bin/bash
srchmm=$1
targethmm=$2
mixupcfg=$3

source ../settings
source ../envconf

echo 'Start mix up!'
rm -rf $LOGDIR/MIXUP
mkdir $LOGDIR/MIXUP
rm -rf $ERRORDIR/MIXUP
mkdir $ERRORDIR/MIXUP

rm -rf $WORKDIR/mixuphed
mkdir $WORKDIR/mixuphed
python $PYSCRP/mixupstep.py $mixupcfg $WORKDIR/mixuphed
mkdir -p $HMMDIR/mix0/mix0hmm4
cp $srchmm/RMF.hmm $HMMDIR/mix0/mix0hmm4/
preline='0'
while read line
do	
	echo 'Mix up : 'mix$line
	mkdir -p $HMMDIR/mix$line/mix$line'hmm0'/
	$HTKTOOL/HHEd  -A -D -T 1 -w $HMMDIR/mix$line/mix$line'hmm0'/RMF.hmm \
					-H $HMMDIR/mix$preline/mix$preline'hmm4'/RMF.hmm \
					$WORKDIR/mixuphed/mixupstep$line.hed \
					$MONOPHONEDIR/monophonesp.ph \
					>$LOGDIR/MIXUP/HHEd.log 2>$ERRORDIR/MIXUP/HHED_mix$line.err
	for ((i=1;i<=4;i++))
	do
		sh $BASHSCRP/hmmestimate.sh $HMMDIR/mix$line/mix$line'hmm'$((i-1)) \
									$HMMDIR/mix$line/mix$line'hmm'$i aligned$MAXFORCEALIGN.lab \
									$MONOPHONEDIR/monophonesp.ph
	done
	preline=$line
done < $CONFIGDIR/mixstep_cfg
rm -rf $targethmm
mkdir $targethmm
cp $HMMDIR/mix$preline/mix$preline'hmm4'/RMF.hmm $targethmm
#rm -rf $HMMDIR/mix*
sh $BASHSCRP/delnulllog.sh $LOGDIR/MIXUP
sh $BASHSCRP/delnulllog.sh $ERRORDIR/MIXUP
echo 'Finish mix up!'