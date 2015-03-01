#/usr/bin/python
import codecs
def correct(scriptfile):
    script=codecs.open(scriptfile,'r','utf-16');
    error=[];
    index=0;
    scriptlines=script.readlines();
    for line in scriptlines:
        if len(line)<4:
            print '%s line: %d \n'%(scriptfile,index);
            error.append(index);
        index+=1;
    script.close();
    if len(error)!=0:
        for err in error :
            scriptlines[err]='\t<STA/> \n';
        script=codecs.open(scriptfile,'w+','utf-16');
        script.writelines(scriptlines);
        script.close();
        
import sys
if __name__=='__main__':
    correct(sys.argv[1]);