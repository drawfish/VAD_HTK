#/bin/bash
srchmm=$1
targethmm=$2

source ../settings
source ../envconf

echo "Fix the sp model!"
rm -rf $ERRORDIR/FIXSP
mkdir $ERRORDIR/FIXSP
rm -rf $LOGDIR/FIXSP
mkdir $LOGDIR/FIXSP

rm -rf $targethmm
mkdir $targethmm
cp $srchmm/RMF.hmm $targethmm/
python $PYSCRP/fixsp.py $targethmm/RMF.hmm 2>$ERRORDIR/FIXSP/FIXSP.err
$HTKTOOL/HHEd -A -D -T 1 -H $targethmm/RMF.hmm -w $targethmm/RMF.hmm \
				 $HED/fixsp.hed $MONOPHONEDIR/monophonesp.ph \
				 > $LOGDIR/FIXSP/HHED.log 2>$ERRORDIR/FIXSP/HHED.err

echo "End fix sp model!"
sh $BASHSCRP/delnulllog.sh $LOGDIR/FIXSP
sh $BASHSCRP/delnulllog.sh $ERRORDIR/FIXSP