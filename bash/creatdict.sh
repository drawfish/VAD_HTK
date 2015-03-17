#/bin/bash
source ../settings
echo 'Start creat dictionary!'
rm -rf $DICTDIR
mkdir $DICTDIR
python $PYSCRP/creatdict.py VAD $DATABASEDICT $DICT $DICTSPSIL
cat $DATABASEEXDICT >> $DICT
cat $DATABASEEXDICT >> $DICTSPSIL
cat $DATABASEENGDICT >> $DICT
cat $DATABASEENGDICTSPSIL >> $DICTSPSIL
cat $DATABASEENGDICT >> $DICTSPSIL
echo 'End creat dictionary!'