function [bm]=newdatacompiler(numberofexposures,numberofconcs,ETnew)

%ij.IJ.run('Macro test 042310 v10 AOI multi pic TEST BEAD STATUS')

noe=numberofexposures;
noc=numberofconcs;
Filepathmatrix=zeros(noe,noc);
dmILP=zeros(noe,noc);
dmSDLP=zeros(noe,noc);
dmCVLP=zeros(noe,noc);
dmICLP=zeros(noe,noc);
dmSDC=zeros(noe,noc);
dmCVC=zeros(noe,noc);
p1='';

fidfirstFile=uipickfiles;
%for i=1:noc
%    if i==1
%        p1='st';    
%    elseif i==2
%        p1='nd';        
%    elseif i==3
%        p1='rd';        
%     else
%        p1='th';
%    end
%   
%
%        [File,Path] = uigetfiles('*.txt',['Choose the ' num2str(i) p1 ' concentration and the first exposure']);
%    fidfirstPath{i}=char(Path);
%    fidfirstFile{i}=char(File);
%
%end

for i=1:noc
   for j=1:noe
        bm{i,j}=strrep(fidfirstFile{i},char(ETnew{1}),ETnew(j));
   end
end

%for i=1:noc
%   para=char(mew{i});
%   for j=1:noe
%  bm{i,j}=[fidfirstFile{i} para(j,:)];
%   end
%end





