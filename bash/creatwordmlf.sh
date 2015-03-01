#/bin/bash
source ../settings
source ../envconf

echo "Creat word level mlf."
rm -rf $WORDMLF
mkdir $WORDMLF

#Max number thread control
mkfifo tmpThread
exec 9<>tmpThread
for ((i=0;i<MAXTHREAD;i++))
do
	echo -ne '\n' 1>&9
done

for phonedir in $WAVDIR/*
do
	for scriptfile in $phonedir/Script/*
	
	do
		if [ -e $scriptfile ];then
			read -u 9
			{
				tmp=${scriptfile/Script/Wav}
				tmp=${tmp/.txt/}
				wmlfpath=${tmp/$WAVDIR/$WORDMLF}
				mkdir -p $wmlfpath
				python $PYSCRP/wordlevmlf.py $scriptfile $MFCCDIR $WAVDIR $wmlfpath
				echo -ne "\n" 1>&9
			}&
		fi
	done
done
wait
rm -rf tmpThread
echo "End word level mlf"