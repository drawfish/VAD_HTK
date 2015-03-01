#/usr/bin/python
def alignedupdatemfcc(forcealignlog,mfccpathfile):
    log=open(forcealignlog,'r');
    mfccpath=open(mfccpathfile,'wt');
    logstr=log.read();
    log.close();
    mfcclogstrs=logstr.split('Aligning File: ');
    for mfcclogstr in mfcclogstrs[1:] :
        mfcclog=mfcclogstr.split('\n');
        if mfcclog[len(mfcclog)-2].find('No tokens survived to final node of network')==-1:
            mfccpath.write("%s\n"%mfcclog[0]);
        else :
            print 'MFCC file delete %s .\n'%mfcclog[0];
    mfccpath.close();

import sys
if __name__=='__main__':
    alignedupdatemfcc(sys.argv[1],sys.argv[2]);        