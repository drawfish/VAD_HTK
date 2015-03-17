#/bin/bash
source ../settings
source ../envconf
model=$TESTBANCH/RMF.hmm3
rm -rf $BANCHVAD
rm -rf $BANCHPLOT
rm -rf $BANCHDIFF
mkfifo tmpVADProcess
exec 9<>tmpVADProcess
for ((i=0;i<$MAXTHREAD;i++))
do
	echo -ne '\n' 1>&9
done

echo "Start VAD test banch."
for phonedirs in $BANCHWAVDIR/* 
do 
	for speakers in $phonedirs/*
	do
		mkdir -p ${speakers/$BANCHWAVDIR/$BANCHVAD}
		mkdir -p ${speakers/$BANCHWAVDIR/$BANCHPLOT}
		mkdir -p ${speakers/$BANCHWAVDIR/$BANCHDIFF}
		for wavfile in $speakers/*
		do
		read -u 9
		{
			tmpvad=${wavfile/$BANCHWAVDIR/$BANCHVAD}
			tmpvad=${tmpvad/.wav/.vad}
			tmpplot=${wavfile/$BANCHWAVDIR/$BANCHPLOT}
			tmpplot=${tmpplot/.wav/.plt}
			tmpdiff=${wavfile/$BANCHWAVDIR/$BANCHDIFF}
			tmpdiff=${tmpdiff/.wav/.dif}
			$TESTBANCH/VAD -m $model -w $wavfile -v $tmpvad -p $tmpplot -d $tmpdiff 
			echo -ne '\n' 1>&9
		} &
		done
	done 
done
rm -rf tmpVADProcess

echo "Finish VAD test bansh."