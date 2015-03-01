#/usr/bin/python
#coding=utf-8
import codecs
import re
def checkEnglish(str):
    pattern2=re.compile(r"[a-zA-Z\<\>\/]");
    if len(re.findall(pattern2,str))==len(str):
        return True;
    else :
        return False;
    
def wordLevMlf(scriptFileName,mfccdir,databasepath,mlfPath):
    mlfFile=open('%s/words.lab'%mlfPath,'wt');
    scriptFile=codecs.open(scriptFileName,'r','utf-16');
    scriptLines=scriptFile.readlines();
    scriptLen=len(scriptLines);
    scriptFile.close();
    
    mlfFile.write('#!MLF!#\n');
    for i in range(0,scriptLen/2):
        realScript=scriptLines[2*i];
        mlfFile.write('\"%s/%s.lab\"\n'
                      %(scriptFileName.replace('Script','Wav').replace(databasepath,mfccdir).replace('.txt','').encode('utf-8'),
                        realScript[0:realScript.find('\t')].encode('utf-8')));
        contex=re.sub("[\s+\.\!_,$%^()+\"\'-——、~@#，。？！：；￥%……&（）“”《》`·．　‘’－—－…【】]+".decode('utf8'),''.decode('utf8'),scriptLines[2*i+1]);
        if checkEnglish(contex):
            mlfFile.write(scriptLines[2*i+1].replace('\t','').replace(' ','\n').encode('utf-8'));
        else :
            isLabel=False;
            for index in range(0,len(contex)):
                mlfFile.write(contex[index].encode('utf-8'));
                if contex[index]=='<':
                    isLabel=True;
                if contex[index]=='>':
                    isLabel=False;
                if not isLabel:
                    mlfFile.write('\n'.encode('utf-8'));     
        mlfFile.write('.\n'.encode('utf-8'));
    mlfFile.close();
import sys    
if __name__=='__main__':
    wordLevMlf(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4]);