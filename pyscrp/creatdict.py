#/usr/bin/python
import sys
import re
def creatdict(olddictfile,newdictfile,newdictspsilfile): 
    olddict=open(olddictfile,'r');
    newdict=open(newdictfile,'wt');
    newdictspsil=open(newdictspsilfile,'wt');
    pattern=re.compile(r'\(\d\)');
    for line in olddict.readlines():
        phone=line.split('\t');
        if phone[1].find('zh')==-1 and phone[1].find('ch')==-1 and phone[1].find('sh')==-1:
            if phone[1][0]=='a' or phone[1][0]=='o' or phone[1][0]=='e' or phone[1][0]=='i' or phone[1][0]=='u' or phone[1][0]=='v':
                consonant='';
                vowel=phone[1];
            else :
                consonant=phone[1][0];
                vowel=phone[1][1:];
        else :
            consonant=phone[1][0:2];
            vowel=phone[1][2:];
        newdict.write('%s\t\t%s %s'%(re.sub(pattern,'',phone[0]),consonant,vowel));
        newdictspsil.write('%s\t\t%s %s sp\n'%(re.sub(pattern,'',phone[0]),
                                              consonant,
                                              vowel.replace('\n','')));
        newdictspsil.write('%s\t\t%s %s sil\n'%(re.sub(pattern,'',phone[0]),
                                              consonant,
                                              vowel.replace('\n','')));
    olddict.close();
    newdict.close();

def creatVADdict(olddictfile,newdictfile,newdictspsilfile):
    olddict=open(olddictfile,'r');
    newdict=open(newdictfile,'w');
    newdictspsil=open(newdictspsilfile,'w');
    for line in olddict.readlines():
        phone=line.split('\t');
        vowel='w';
        if phone[0].find('\(')==-1:
            newdict.write('%s\t\t%s\n'%(phone[0],vowel));
            newdictspsil.write('%s\t\t%s sp \n'%(phone[0],vowel));
            newdictspsil.write('%s\t\t%s sil \n'%(phone[0],vowel));
            newdictspsil.write('%s\t\t%s \n'%(phone[0],vowel));
    olddict.close();
    newdict.close();

if __name__=='__main__':
    if sys.argv[1]=='VAD' :
        creatVADdict(sys.argv[2], sys.argv[3],sys.argv[4]);
    else :
        creatdict(sys.argv[2],sys.argv[3],sys.argv[4]);
    