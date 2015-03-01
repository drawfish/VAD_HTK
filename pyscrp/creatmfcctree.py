#usr/bin/python
import re
import sys
import os
def creatMFCCTree(wavdir,mfccdir):
    for parent,dirnames,filenames in os.walk(wavdir):
        for dirname in dirnames:
            if dirname.find('Script')==-1:
                path=os.path.join(parent,dirname).replace(wavdir,mfccdir).replace('Session0','');
                os.system('mkdir -p %s'%path);
            
if __name__=='__main__':
    creatMFCCTree(sys.argv[1],sys.argv[2]);