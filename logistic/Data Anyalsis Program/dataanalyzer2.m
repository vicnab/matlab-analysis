function [Fitdata,Fitdatagof,Fitdataoutput,Fitdataresiduals,Fitdatayy,Fitdataresid]= dataanalyzer (numberofcontrols,xarray,yarray,ET)
noc=numberofcontrols;
sizex=size(xarray);
[sizey,pp]=size(yarray);

%if sizex+sizey=2*sizex
%    display ('Your x and y array are not the same size.  Check the arrays please.');
%
%end

xarray1=xarray(1:noc);
exposurecounter=sizey/noc;
counter=0;
ymatrix=ones(noc,exposurecounter);
for i=1:exposurecounter
ymatrix(1:noc,i)=yarray(counter*noc+1:counter*noc+noc);
counter=counter+1;
end

for i=1:exposurecounter
  figure(ET(i));
  %axis=[0 max(xarray) 0 25];

yarray1=ymatrix(1:noc,i);    
[fresult,gof,output,yy,residuals,fresult2,gof2,output2,fresult3,gof3,output3]= powerfit(xarray1,yarray1);
Fitdata{i}=[fresult];
Fitdatagof{i}=[gof];
Fitdataoutput{i}=[output];
Fitdatayy{i}=[yy];
residuals;
xxx=linspace(1,1000000,1000);
yyy=fresult(xxx);
yyy2=fresult2(xxx);
yyy3=fresult3(xxx);
Fitdataresiduals{i}=[residuals];

semilogx(xxx,yyy,xxx,yyy2,xxx,yyy3,xarray1,yarray1,'x');
legend ('my 5 parameter','5 parameter','4 parameter','data','location','NorthWest');
mom(i,:) = residuals;
title=(num2str(ET(i)));

Fitdataresid(i)=sum(mom(i,:));

end

Fitdataresid;