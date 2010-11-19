function [MDCM,MaxDCM]=imageJstarterTrp
load('mySaveTrp.mat')
load(fullfile(pwd, 'mySaveTrp.mat'))

%imageJstarter(7,5)
javaaddpath 'mij.jar'
javaaddpath 'ij.jar'
%MIJ.start

% opener = ij.io.Opener();
% if isjava(opener) == 0
%     sprintf('%s', 'MIJ Message: the ImageJ is not properly installed in the java folder of Matlab.')
%     image = 0;
%     return
% end
noe=input('Enter the number of exposures ');
noc=input('Enter the number of concentrations ');
%[ETnew,xarray,ET]=cellmaker(numberofexposures,noc);

%fileopener(noc);

[bm,CBM]=autodatacompiler(9,5);
[dmILP,dmSDLP,dmCVLP,dmICLP,dmSDC,dmCVC]=datacompiler(noe,noc,bm);
[CMILP,CSDLP,CdmCVLP,CdmICLP,CdmSDC,CdmCVC]=datacompiler(noe,1,CBM);
[Fitdata,Fitdatagof,Fitdataoutput,Fitdataresid,MDCM,MaxDCM,h]= dataanalyzer4trp (xarray,dmILP,ET,dmSDLP,ETnew,CMILP,CSDLP);

 save('mySaveTrp.mat')
 save(fullfile(pwd, 'mySaveTrp.mat'))

