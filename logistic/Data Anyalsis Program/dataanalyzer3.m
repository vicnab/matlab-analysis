function [Fitdata,Fitdatagof,Fitdataoutput,Fitdatayy,Fitdataresid,yyy,yyy2,yyy3,range2x,range2y,rr2,currenty,currentx,currentymax,currentxmax,xxx,MDCM,MaxDCM]= dataanalyzer3 (xarray,ymatrix,ET,sdmatrix,ETnew)
%[Fitdata,Fitdatagof,Fitdataoutput,Fitdataresiduals,Fitdatayy,Fitdataresid,yyy,yyy2,yyy3,range2x,range2y,rr2,currenty,currentx]= dataanalyzer (8,xx',bigy,ET,bigsd);
tic
[numberofexposures,numberofcontrols]=size(ymatrix);
noc=numberofcontrols;
sizex=size(xarray);

xarray1=xarray;
exposurecounter=numberofexposures;
counter=0;

figure(1);

for i=1:exposurecounter
  
yarray1=ymatrix(i,1:noc)'   
sdarray1=sdmatrix(i,1:noc)'
[fresult,gof,output,yy,resid,fresult3,gof3,output3,weightvector]= powerfit(xarray1,yarray1,sdarray1);
Fitdata{i}=[fresult];
Fitdata2{i}=[fresult3];
Fitdatagof{i}=[gof];
Fitdataoutput{i}=[output];
Fitdatayy{i}=[yy];
weightvectormatrix{i}=weightvector;

xxx=logspace(-2,4,10000);
yyyy=linspace(min(yarray1),255,1000);
yyy(i,:)=fresult(xxx);
yyy2(i,:)=fresult(xxx);
yyy3(i,:)=fresult3(xxx);

yy=fresult(xxx);
min(yy);
3*sdarray1(noc)
minimum=min(yy)+3*sdarray1(1);
maximum=254-3*sdarray1(noc)
[a1,b1,c1]=find(yy<minimum);
[a2,b2,c2]=find(yy<maximum);
MDC = xxx(max(a1));
MaxDC = xxx(max(a2))
MDCM(i)=MDC;
MaxDCM(i)=MaxDC;

subplot(4,2,i,'replace');
loglog(xxx,yyy2(i,:),xxx,yyy3(i,:),xarray1,yarray1,'x',[10^-2, 10^4],[minimum,minimum ],'b--',[10^-2, 10^4],[maximum,maximum],'b--');
title([num2str(ET(i)), ' Intensity. MDC = ',num2str(MDC), 'ng/ml', ', and your MaxDC is ', num2str(MaxDC),' ng/ml.' ])
legend ('5 parameter SD Weights','4 parameter','data','location','NorthWest');
mom(i,:) = resid;


Fitdataresid(i)=sum(mom(i,:));


yyy2i=[find(255>yyy2(i:i,:))];
yyy2ii=[find(yyy2(i:i,1:max(yyy2i))>1.05*min(yyy2(i:i,:)))];
dx2=max(xxx(yyy2ii))- min(xxx(yyy2ii));
dy2=max(yyy2(yyy2ii))- min(yyy2(yyy2ii));
range2x(i)=dx2;
range2y(i)=dy2;
rr2(i,1)=dx2*dy2;
 [a,b,c]=find(yyy(i:i,:)>1.05*min(yyy(i:i,:)));
 [d,e,f]=find(yyy(i:i,:)<250);
currenty(i)= yyy(i:i,min(b));
currentx(i)=[ xxx(min(b))];
currentymax(i)=[ yyy(i:i,max(e))];
currentxmax(i)=[ xxx(max(e))];

end

toc
pp=-1;
i=numberofexposures;
[unkbm]=newdatacompiler2(numberofexposures,1,ETnew);
[dmILP2,dmSDLP2,dmCVLP2,dmICLP2,dmSDC2,dmCVC2]=datacompiler(numberofexposures,1,unkbm); 

while(pp==-1)
 i;
unk=dmILP2(i,1);
sd=dmSDLP2(i,1);
%unk = input('Enter Unknown Intensity ');
%sd = input('Enter Unknown SD ');
%FTU = input('Choose Fit to Use ');
if unk <250
    pp=1;
else
    i=i-1;
   
%unk=dmILP(i,1)
%sd=dmSDLP(i,1)

end
if i==1
pp=1;
end


end
i;
unk=dmILP2(i,1);
sd=dmSDLP2(i,1);
%figure(3);
%aa=Fitdata{i};
%semilogx(xxx,aa(xxx));
%xlsPasteTo('Data.xlsx','Sheet1',1000, 1000,'A1')
yarray1=ymatrix(i,1:noc)'; 
xarray1;
sdarray1=sdmatrix(i,1:noc)';
[unkconc]=unknownfinder(Fitdata{i},Fitdata2{i},unk,sd,ET(i),xarray1,yarray1,sdarray1);



if unkconc>max(xarray)
    disp('Warning: unknown concentration is above maximum known concentration.')
end
fdg=Fitdatagof{i};
sse=fdg.sse;
rsquare=fdg.rsquare;
dfe=fdg.dfe;
adjsquare=fdg.adjrsquare;
rmse=fdg.rmse;
FDGmatrix1={['sum of squares'];['r square '];['degrees of freedom'];['adjsquare'];['rmse'];['Algorithm Used']}
FDGmatrix2={[sse];[rsquare];[dfe];[adjsquare];[rmse];[Fitdataoutput{i}.algorithm]}
%unk = input('Enter name of file');
%xlswrite('Data.xlsx',FDGmatrix1,'Sheet3','A1')
%xlswrite('Data.xlsx',FDGmatrix2,'Sheet3','B1')
%xlsPasteTo('Data.xlsx','Sheet2',1000, 1000,'A2')
