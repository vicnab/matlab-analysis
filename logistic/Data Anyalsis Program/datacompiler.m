function[dmILP,dmSDLP,dmCVLP,dmICLP,dmSDC,dmCVC]= datacompiler(numberofexposures,numberofconcs,bm)
noe=numberofexposures;
noc=numberofconcs;
dmILP=zeros(noe,noc);
dmSDLP=zeros(noe,noc);
dmCVLP=zeros(noe,noc);
dmICLP=zeros(noe,noc);
dmSDC=zeros(noe,noc);
dmCVC=zeros(noe,noc);
%[bm]=newdatacompiler(noe,noc,ETnew)
bm=bm';
for i=1:noe
%if i==1
%    p1='Choose the smallest exposure ';
%else
%    p1='Choose the next largest exposure ';
%end
for f=1:noc
%    if f==1
%        p2='and the smallest concentration';
%    else
%        p2='and the next largest concentration';
%    end
%    path = pwd;
%    dlg = ij.io.OpenDialog([p1 ' ' p2], '');
%    path = dlg.getDirectory;
%    name = dlg.getFileName();
%   fid = dlg.getDirectory().concat(dlg.getFileName())
   fid=[char(bm{i,f})];
   [I_Lp,Sd_Lp,CV_Lp,I_C,Sd_C,CV_C]= datareader(fid);
    dmILP(i,f)=I_Lp;
    dmSDLP(i,f)=Sd_Lp;
    dmCVLP(i,f)=CV_Lp;
    dmICLP(i,f)=I_C;
    dmSDC(i,f)=Sd_C;
    dmCVC(i,f)=CV_C;
end

end


    
    