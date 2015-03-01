#/usr/bin/python
#coding=utf-8
import codecs
def wordLevMlf(scriptFileName,mfccpath,databasepath,mlfPath):
    mlfFile=open('%s/words.lab'%mlfPath,'wt');
    scriptFile=codecs.open(scriptFileName,'r','utf-16');
    scriptLines=scriptFile.readlines();
    scriptLen=len(scriptLines);
    scriptFile.close();
    
    mlfFile.write('#!MLF!#\n');
    for i in range(0,scriptLen/2):
        realScript=scriptLines[2*i];
        mlfFile.write('\"%s/%s.lab\"\n'
                      %(scriptFileName.replace('Script','Wav').replace(databasepath,mfccpath).replace('.txt',''),
                        realScript[0:realScript.find('\t')].encode('utf-8')));
        contex=scriptLines[2*i+1].replace('\t','').replace(' ','');
        isLabel=False;
        for index in range(0,len(contex)-2):
            if contex[index]=='<':
                isLabel=True;
            if contex[index]=='>':
                mlfFile.write('SIL\n'.encode('utf-8'));   
                isLabel=False;
            if not isLabel and contex[index]!='>':
                mlfFile.write('W\n'.encode('utf-8'));                
        mlfFile.write('.\n'.encode('utf-8'));
    mlfFile.close();
import sys    
if __name__=='__main__':
    wordLevMlf(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4]);