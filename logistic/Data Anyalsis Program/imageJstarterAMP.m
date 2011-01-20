function [yyy2,xxx,MDCM,MaxDCM]=imageJstarterCOC
load('mySaveAMP.mat')
load(fullfile(pwd, 'mySaveAMP.mat'))
%xarray=xx;
%imageJstarter(7,5)
javaaddpath 'C:\Program Files\MATLAB\R2010a\java\jar\mij.jar'
javaaddpath 'C:\Program Files\MATLAB\R2010a\java\jar\ij.jar'
%MIJ.start

%opener = ij.io.Opener();
%if isjava(opener) == 0
%    sprintf('%s', 'MIJ Message: the ImageJ is not properly installed in the java folder of Matlab.')
%    image = 0;
%    return
%end
numberofexposures=input('Enter the number of exposures ');
noc=input('Enter the number of concentrations ');
[ETnew,xarray3,ET]=cellmaker(numberofexposures,noc);

%fileopener(numberofconcs);
[bm]=newdatacompiler(numberofexposures,noc,ETnew);
[CBM]=newdatacompiler(numberofexposures,1,ETnew);
[dmILP,dmSDLP,dmCVLP,dmICLP,dmSDC,dmCVC]=datacompiler(numberofexposures,noc,bm);
[CMILP,CSDLP,CdmCVLP,CdmICLP,CdmSDC,CdmCVC]=datacompiler(numberofexposures,1,CBM);
%[Fitdata,Fitdatagof,Fitdataoutput,Fitdatayy,Fitdataresid,yyy,yyy2,xxx,MDCM,MaxDCM,h]= dataanalyzer4AMP(xarray3,dmILP,ET,dmSDLP,ETnew,CMILP,CSDLP);

 save('mySaveamp.mat')
 save(fullfile(pwd, 'mySaveamp.mat'))

