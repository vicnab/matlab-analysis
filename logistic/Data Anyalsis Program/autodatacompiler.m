function [bm,cbm]=autodatacompiler(numberofexposures,numberofconcs)


noe=numberofexposures;
noc=numberofconcs;
bm=[];
p1='';

MasterPath=['/Users/Ben/matlab-analysis/logistic/Data Anyalsis Program/Inputfiles'];
ppbm=getAllFiles(MasterPath);
counter=1;
for i=1:numel(ppbm)
k = findstr(['step5'], ppbm{i});
if numel(k)~=0
    pbm(counter)={char(ppbm(i))};
    counter=counter+1;
else
end
end
    

  counter=1;  
 for i=1:noc
    for j=1:noe
         bm{i,j}=pbm{counter};
        counter=counter+1;
    end
 end

 
 MasterPath=['Users/Ben/matlab-analysis/logistic/Data Anyalsis Program/Control Files'];
cppbm=getAllFiles(MasterPath);
ccounter=1;
for i=1:numel(cppbm)
k = findstr(['step5'], cppbm{i});
if numel(k)~=0
    cpbm(ccounter)={char(cppbm(i))};
    ccounter=ccounter+1;
else
end
end
    

  ccounter=1;  
 i=1;
    for j=1:noe
         cbm{i,j}=pbm{ccounter};
        ccounter=ccounter+1;
    end
 






