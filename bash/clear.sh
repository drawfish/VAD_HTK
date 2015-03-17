#/bin/bash
source ../settings
echo "Clean up!"
rm -rf $WORKDIR/dict &
rm -rf $WORDMLF &
rm -rf $PHONEMLF &
rm -rf $HMMDIR/* &
rm -rf $LOGDIR &
rm -rf $ERRORDIR &
rm -rf $TMPDIR &
rm -rf $WORKDIR/mixuphed &
rm -rf $MFCCPATH &
rm -rf $WAVPATH &
rm -rf $SCPPATH &
rm -rf $WORKDIR/bash/nohup.out &
wait
echo "Finish clean up."

