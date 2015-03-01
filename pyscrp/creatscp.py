#/usr/bin/python
import re
import sys
def createscp(wavpathfile,wavdirroot,mfccdirroot,scppathfile):
    wav=open(wavpathfile,'r');
    scp=open(scppathfile,'wt');
    for line in wav.readlines():
        scp.write('%s %s'%(line.replace('\n',' '),
                           line.replace(wavdirroot,mfccdirroot)
                           .replace('/Session0','').replace('.wav','.mfc')));
    wav.close();
    scp.close();

if __name__=='__main__':
    createscp(sys.argv[1], sys.argv[2],sys.argv[3],sys.argv[4]);  