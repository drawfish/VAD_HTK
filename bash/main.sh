#/bin/bash
source ../settings

#rm -rf $LOGDIR
#rm -rf $ERRORDIR
#mkdir $LOGDIR
#mkdir $QSUBLOG
#mkdir $ERRORDIR

#sh $BASHSCRP/creatdict.sh 
#sh $BASHSCRP/coding.sh
#sh $BASHSCRP/creatwordmlf.sh 
#sh $BASHSCRP/creatphone0mlf.sh
#sh $BASHSCRP/creatmonophone.sh $HMMDIR/hmm0
#for ((hmm_Index=1;hmm_Index<=4;hmm_Index++))
#do
	#sh $BASHSCRP/hmmestimate.sh $HMMDIR/hmm$((hmm_Index-1)) \
								#$HMMDIR/hmm$hmm_Index phone0s.lab \
								#$MONOPHONEDIR/monophone0.ph
#done
#hmm_Index=5
#sh $BASHSCRP/fixsp.sh $HMMDIR/hmm$((hmm_Index-1)) $HMMDIR/hmm$hmm_Index 
#sh $BASHSCRP/creatphonespmlf.sh 
#for ((hmm_Index=6;hmm_Index<=9;hmm_Index++))
#do
	#	sh $BASHSCRP/hmmestimate.sh $HMMDIR/hmm$((hmm_Index-1)) \
								#								$HMMDIR/hmm$hmm_Index phonesp.lab \
								#								$MONOPHONEDIR/monophonesp.ph
#done
#hmm_Index=5
#for ((alignNum=1;alignNum<=$MAXFORCEALIGN;alignNum++))
#do
	#hmm_base=$((hmm_Index-1))
	#sh $BASHSCRP/forcealign.sh $HMMDIR/hmm$hmm_base aligned$alignNum.lab monophone0.ph
	#for ((;hmm_Index<=$((hmm_base+4));hmm_Index++))
	#do
		#sh $BASHSCRP/hmmestimate.sh $HMMDIR/hmm$((hmm_Index-1)) \
									#$HMMDIR/hmm$hmm_Index aligned$alignNum.lab \
									#$MONOPHONEDIR/monophone0.ph
	#done
#done
hmm_Index=13
sh $BASHSCRP/mixup.sh $HMMDIR/hmm$((hmm_Index-1)) $HMMDIR/hmm$hmm_Index $CONFIGDIR/mixstep_cfg monophone0.ph
echo "Finish the VAD Training."
