#/bin/bash
source ./settings
model=$1
rm -rf $BANCHVAD
rm -rf $BANCHPLOT
rm -rf $BANCHDIFF

for phonedirs in $BANCHWAV/* 
do 
	for speakers in $phonedirs/*
	do
		for wavfile in $speakers/*
		do
			tmpvad=${wavfile/$BANCHWAV/$BANCHVAD}
			tmpplot=${wavfile/$BANCHWAV/$BANCHPLOT}
			tmpdiff=${wavfile/$BANCHWAV/$BANCHDIFF}
			$TESTBANCH/VAD -m $model -w $wavfile -v $tmpvad -p $tmpplot -d $tmpdiff 
		done
	done 
done