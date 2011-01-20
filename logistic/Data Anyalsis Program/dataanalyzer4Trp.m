function [Fitdata,Fitdatagof,Fitdataoutput,Fitdataresid,MDCM,MaxDCM,h,Fitdatan]= dataanalyzer4trp (xarray1,ymatrix,ET,sdmatrix,ETnew,CMILP,CSDLP)
%[Fitdata,Fitdatagof,Fitdataoutput,Fitdataresiduals,Fitdatayy,Fitdataresid,yyy,yyy2,yyy3,range2x,range2y,rr2,currenty,currentx]= dataanalyzer (8,xx',bigy,ET,bigsd);
tic
[numberofexposures,numberofcontrols]=size(ymatrix);
noc=numberofcontrols;
sizex=size(xarray1);


exposurecounter=numberofexposures;
counter=0;

h(1)=figure(1);

for i=1:numberofexposures
  format long
yarray1=ymatrix(i,1:noc)'  ;
sdarray1=sdmatrix(i,1:noc)';
[fresult,gof,output,resid,fresult3,gof3,output3,weightvector]= powerfit4(xarray1,yarray1,sdarray1);
Fitdata{i}=fresult;
Fitdatan(i,1)=fresult.v;
Fitdatan(i,2)=fresult.a;
Fitdatan(i,3)=fresult.c;
Fitdatan(i,4)=fresult.b;
Fitdatan(i,5)=fresult.g;
Fitdata2{i}=[fresult3];
Fitdatagof{i}=[gof];
Fitdataoutput{i}=[output];
%Fitdatayy{i}=[yy];
weightvectormatrix{i}=weightvector;

xxx=logspace(-2,3,100);

yyy(i,:)=fresult(xxx);
yyy2(i,:)=fresult(xxx);
yyy3(i,:)=fresult3(xxx);

yy=fresult(xxx);

 cSD=CSDLP(i);
 sdbb=sdarray1(numberofcontrols);
 if sdarray1(5)==0
     sdbb=max(sdarray1);
 end
 if cSD==0
     cSD=.01*CMILP(i);
 end
 

 
maximum=max(yarray1)-3*sdarray1(numberofcontrols);
minimum=CMILP(i)+3*CSDLP(i);
MaxDC=max(xarray1);
MDC=min(xarray1);

[a1,b1,c1]=find(yy>minimum);
[a2,b2,c2]=find(yy<maximum);


MDC = xxx(min(a1));
MaxDC = max(a2);


subplot(3,3,i);
kk=semilogx(xxx,yyy2(i,:),'b',xxx,yyy3(i,:),'k',xarray1,yarray1,'rx',[MDC, MDC],[0,300 ],'b--',[MaxDC, MaxDC],[0,300],'b--',[10^-2 10^3],[minimum minimum],'b--');
set(kk,'LineWidth',2);
format short
title(['Exposure time ', num2str(i),'. MDC = ',num2str(MDC), ' ng/ml', ',MaxDC = ', num2str(MaxDC),' ng/ml.' ],'Fontsize',10);
xlabel('Concentration of Drug (ng/ml)','Fontsize',12)
ylabel('Signal Intensity (a.u.) ','Fontsize',12)
mom(i,:) = resid;

legend ('5 parameter','my 4 parameter','data','location','best');
Fitdataresid(i)=sum(mom(i,:));




legend ('5 parameter SD Weights','4 parameter','Known Data','location','Best');
end


set(figure(1), 'paperunits', 'inches', 'paperposition', [0 0 18 15])
%print(figure(1),'-dtiff','-r300', 'C:\Documents and Settings\carevalos\Desktop\McDevitt Lab\Data Anyalsis Program\Trp\Trp known.tif')

 pp=-1;
i=numberofexposures;
%c=input('Enter the number of unknowns to test ');
[unkbm,c]=unknownautodatacompiler(numberofexposures);

[dmILP2,dmSDLP2,dmCVLP2,dmICLP2,dmSDC2,dmCVC2]=datacompiler(numberofexposures,c,unkbm); 
% 
for p=1:c
    pp=-1;
    i=numberofexposures;
 while(pp==-1)
  
unk=dmILP2(i,p:p);
sd=dmSDLP2(i,p:p);
yarray1=ymatrix(i,1:noc)';
sdarray1=sdmatrix(i,1:noc)';


minimum=min(yarray1)+(sdbb);
sdb=sdarray1(numberofcontrols);
 if sdarray1(5)==0
     sdbb=max(sdarray1);
 end
 if i==1
break
 end
 cSD=CSDLP(i);
 if cSD==0
     cSD=.01*CMILP(i);
 end
 
 maximum=CMILP(i)-3*cSD;
if unk <CMILP(i)-3*cSD && unk<max(yarray1);
     pp=1;
 else
     i=i-1;
    
unk=dmILP2(i,p:p);
sd=dmSDLP2(i,p:p);
 
 end
 
 

 end
 i;
 unkk=dmILP2(i,p:p);
 sd=dmSDLP2(i,p:p);
 
 aa=Fitdata{i};

 yarray1=ymatrix(i,1:noc)'; 
 
 sdarray1=sdmatrix(i,1:noc)';
 MDCM(i)=MDC;
MaxDCM(i)=MaxDC;
[unkconc]=unknownfinderTrp(Fitdata{i},Fitdata2{i},unk,sd,ETnew(i),xarray1,yarray1,sdarray1,p+1,CMILP(i),CSDLP(i),h); 

 
if unkconc>max(xarray1)
   disp('Warning: unknown concentration is above maximum known concentration.')
end
fdg=Fitdatagof{i};
sse=fdg.sse;
rsquare=fdg.rsquare;
dfe=fdg.dfe;
adjsquare=fdg.adjrsquare;
rmse=fdg.rmse;
FDGmatrix1{p}={['sum of squares'];['r square '];['degrees of freedom'];['adjsquare'];['rmse'];['Algorithm Used']};
FDGmatrix2{p}={[sse];[rsquare];[dfe];[adjsquare];[rmse];[Fitdataoutput{i}.algorithm]};
end
toc
%unk = input('Enter name of file');
%xlswrite('Data.xlsx',FDGmatrix1,'Sheet3','A1')
%xlswrite('Data.xlsx',FDGmatrix2,'Sheet3','B1')
%xlsPasteTo('Data.xlsx','Sheet2',1000, 1000,'A2')
