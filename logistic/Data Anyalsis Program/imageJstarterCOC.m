function [yyy2,xxx,MDCM,MaxDCM]=imageJstarterCOC
load('mySavecoc.mat')
load(fullfile(pwd, 'mySavecoc.mat'))
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
[ETnew,xarray3]=cellmaker(numberofexposures,noc);

%fileopener(numberofconcs);
[bm]=newdatacompiler(numberofexposures,numberofconcs,ETnew);
[dmILP,dmSDLP,dmCVLP,dmICLP,dmSDC,dmCVC]=datacompiler(numberofexposures,numberofconcs,bm);
[Fitdata,Fitdatagof,Fitdataoutput,Fitdatayy,Fitdataresid,yyy,yyy2,xxx,MDCM,MaxDCM]= dataanalyzer4coc(xarray3,dmILP,ET,dmSDLP,ETnew);

 save('mySaveamp.mat')
 save(fullfile(pwd, 'mySavecocamp.mat'))

