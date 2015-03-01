#/usr/bin/python
def devidefile(trainFile,subFilePath,codeNum):
    trainf=open(trainFile,'r');
    lines=trainf.readlines();
    totalLine=len(lines);
    perfileLine=totalLine/int(codeNum);
    for i in range(0,int(codeNum)+1):
        subtrainf=open('%s/train%d.tmp'%(subFilePath,i),'wt');
        if perfileLine*(i+1)<totalLine :
            subtrainf.writelines(lines[perfileLine*i:perfileLine*(i+1)]);
        else :
            subtrainf.writelines(lines[perfileLine*i:totalLine])
        subtrainf.close();
    trainf.close();
    
import sys
if __name__=='__main__':
    devidefile(sys.argv[1],sys.argv[2],sys.argv[3]);