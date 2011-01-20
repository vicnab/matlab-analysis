function [yyy2,xxx,MDCM,MaxDCM]=imageJstarter(numberofexposures,numberofconcs,Fitdata,bm)
load('mySave.mat')
load(fullfile(pwd, 'mySave.mat'))
xarray=xx;
%imageJstarter(7,5)
javaaddpath 'C:\Program Files\MATLAB\R2010a\java\jar\mij.jar'
javaaddpath 'C:\Program Files\MATLAB\R2010a\java\jar\ij.jar'
%MIJ.start

opener = ij.io.Opener();
if isjava(opener) == 0
    sprintf('%s', 'MIJ Message: the ImageJ is not properly installed in the java folder of Matlab.')
    image = 0;
    return
end
numberofexposures=input('Enter the number of exposures ');
noc=input('Enter the number of concentrations ');
[ETnew,xarray3,ET]=cellmaker(numberofexposures,noc);
%numberofconcs=5;
%fileopener(noc);

[bm]=newdatacompiler(numberofexposures,numberofconcs,ETnew);
[dmILP,dmSDLP,dmCVLP,dmICLP,dmSDC,dmCVC]=datacompiler(numberofexposures,numberofconcs,bm);
[CMILP,CSDLP,CdmCVLP,CdmICLP,CdmSDC,CdmCVC]=datacompiler(numberofexposures,1,CBM);
[Fitdata,Fitdatagof,Fitdataoutput,Fitdatayy,Fitdataresid,yyy,yyy2,yyy3,xxx,MDCM,MaxDCM,h]= dataanalyzer4trp (xarray3,dmILP,ET,dmSDLP,ETnew,CMILP,CSDLP)
%[Fitdata,Fitdatagof,Fitdataoutput,Fitdatayy,Fitdataresid,yyy,yyy2,yyy3,range2x,range2y,rr2,currenty,currentx,currentymax,currentxmax,xxx,MDCM,MaxDCM]= dataanalyzer3(xarray2,dmILP,ET,dmSDLP,ETnew);

 save('mySave.mat')
 save(fullfile(pwd, 'mySave.mat'))

