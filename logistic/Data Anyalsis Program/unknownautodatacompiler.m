function [ubm,noc]=uautodatacompiler(numberofexposures)


noe=numberofexposures;

ubm=[];
p1='';

MasterPath=['C:\Documents and Settings\carevalos\Desktop\McDevitt Lab\Data Anyalsis Program\UnknownFiles'];
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
  [o,p]=size(pbm);
noc=p/noe;
  counter=1;  
 for i=1:noc
    for j=1:noe
         ubm{i,j}=pbm{counter};
        counter=counter+1;
    end
 end

%  
%  MasterPath=['C:\Documents and Settings\carevalos\My Documents\My Dropbox\Data analysis software effort\Updated Program\UnknownFiles'];
% cppbm=getAllFiles(MasterPath);
% ccounter=1;
% for i=1:numel(cppbm)
% k = findstr(['step5'], cppbm{i});
% if numel(k)~=0
%     cpbm(ccounter)={char(cppbm(i))};
%     ccounter=ccounter+1;
% else
% end
% end
%     
% 
%   ccounter=1;  
%  i=1;
%     for j=1:noe
%          cbm{i,j}=pbm{ccounter};
%         ccounter=ccounter+1;
%     end
%  






