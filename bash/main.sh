#/bin/bash
source ../settings

rm -rf $LOGDIR
rm -rf $ERRORDIR
mkdir $LOGDIR
mkdir $QSUBLOG
mkdir $ERRORDIR

sh $BASHSCRP/creatdict.sh 
sh $BASHSCRP/coding.sh
sh $BASHSCRP/creatwordmlf.sh 
sh $BASHSCRP/creatphone0mlf.sh
sh $BASHSCRP/creatmonophone.sh $HMMDIR/hmm0
hmm_Index=1
for ((;hmm_Index<=$MAXRESTIMATE;hmm_Index++))
do
	sh $BASHSCRP/hmmestimate.sh $HMMDIR/hmm$((hmm_Index-1)) \
								$HMMDIR/hmm$hmm_Index phone0s.lab \
								$MONOPHONEDIR/monophone0.ph
done
hmm_Index=$((MAXRESTIMATE+1))
sh $BASHSCRP/fixsp.sh $HMMDIR/hmm$((hmm_Index-1)) $HMMDIR/hmm$hmm_Index 
sh $BASHSCRP/creatphonespmlf.sh 
for ((hmm_Index=$((MAXRESTIMATE+2));hmm_Index<=$((2*MAXRESTIMATE+1));hmm_Index++))
do
		sh $BASHSCRP/hmmestimate.sh $HMMDIR/hmm$((hmm_Index-1)) \
																$HMMDIR/hmm$hmm_Index phonesp.lab \
																$MONOPHONEDIR/monophonesp.ph
done
hmm_Index=$((2*MAXRESTIMATE+2))
for ((alignNum=1;alignNum<=$MAXFORCEALIGN;alignNum++))
do
	hmm_base=$((hmm_Index-1))
	sh $BASHSCRP/forcealign.sh $HMMDIR/hmm$hmm_base aligned$alignNum.lab monophonesp.ph
	for ((;hmm_Index<=$((hmm_base+MAXRESTIMATE));hmm_Index++))
	do
		sh $BASHSCRP/hmmestimate.sh $HMMDIR/hmm$((hmm_Index-1)) \
									$HMMDIR/hmm$hmm_Index aligned$alignNum.lab \
									$MONOPHONEDIR/monophonesp.ph
	done
done
hmm_Index=$((2*MAXRESTIMATE+2+MAXRESTIMATE*MAXFORCEALIGN))
sh $BASHSCRP/mixup.sh $HMMDIR/hmm$((hmm_Index-1)) $HMMDIR/hmm$hmm_Index $CONFIGDIR/mixstep_cfg monophonesp.ph
hmm_Index=$((2*MAXRESTIMATE+2+MAXRESTIMATE*MAXFORCEALIGN+1))
for ((alignNum=$((MAXFORCEALIGN+1));alignNum<=$((MAXFORCEALIGN*2));alignNum++))
do
	hmm_base=$((hmm_Index-1))
	sh $BASHSCRP/forcealign.sh $HMMDIR/hmm$hmm_base aligned$alignNum.lab monophonesp.ph
	for ((;hmm_Index<=$((hmm_base+MAXRESTIMATE));hmm_Index++))
	do
		sh $BASHSCRP/hmmestimate.sh $HMMDIR/hmm$((hmm_Index-1)) \
									$HMMDIR/hmm$hmm_Index aligned$alignNum.lab \
									$MONOPHONEDIR/monophonesp.ph
	done
done
echo "Finish the VAD Training."
