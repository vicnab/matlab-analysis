function [Fitdata,Fitdatagof,Fitdataoutput,Fitdatayy,Fitdataresid,yyy,yyy2,yyy3,xxx,MDCM,MaxDCM,h]= dataanalyzer4coc2 (xarray1,ymatrix,ET,sdmatrix,ETnew,CMILP,CSDLP)
%[Fitdata,Fitdatagof,Fitdataoutput,Fitdataresiduals,Fitdatayy,Fitdataresid,yyy,yyy2,yyy3,range2x,range2y,rr2,currenty,currentx]= dataanalyzer (8,xx',bigy,ET,bigsd);
tic
[numberofexposures,numberofcontrols]=size(ymatrix);
noc=numberofcontrols;
sizex=size(xarray1);

xarray1=xarray1;
exposurecounter=numberofexposures;
counter=0;

h(1)=figure(1);

for i=1:numberofexposures
  
yarray1=ymatrix(i,1:noc)'  
sdarray1=sdmatrix(i,1:noc)'
[fresult,gof,output,yy,resid,fresult3,gof3,output3,weightvector]= powerfit4dia(xarray1,yarray1,sdarray1,CMILP(i));
Fitdata{i}=[fresult];
Fitdata2{i}=[fresult3];
Fitdatagof{i}=[gof];
Fitdataoutput{i}=[output];
Fitdatayy{i}=[yy];
weightvectormatrix{i}=weightvector;

xxx=logspace(log10(xarray1(1)),1,100);

yyy(i,:)=fresult(xxx);
yyy2(i,:)=fresult(xxx);
yyy3(i,:)=fresult3(xxx);

yy=fresult(xxx);
3*sdarray1(noc);

 cSD=CSDLP(i);
 sdbb=sdarray1(numberofcontrols);
 if sdarray1(5)==0
     sdbb=max(sdarray1);
 end
 if cSD==0
     cSD=.01*CMILP(i);
 end
 
maximum=CMILP(i)-3*cSD;
minimum=min(yarray1)+(sdbb);
MaxDC=max(xarray1);
MDC=min(xarray1);
new=0;
if maximum<minimum
   new=maximum;
   %maximum=minimum
   minimum=new;
end
[a1,b1,c1]=find(yy>minimum);
[a2,b2,c2]=find(yy<maximum);
%if max(yy)<maximum
%    MDC=min(xarray1);
%else


    MDC = xxx(min(a2));
%end
%if min(yy)>minimum
%    MaxDC=max(xarray1);
%else
    MaxDC = xxx(max(a1));
%end


% if min(yy)<minimum
%     MaxDC=maximum
% end
if new==minimum
    MaxDC=MDC;
end

MDCM(i)=MDC;
MaxDCM(i)=MaxDC;

subplot(4,2,i);
kk=semilogx(xxx,yyy2(i,:),'b',xxx,yyy3(i,:),'k',xarray1,yarray1,'ks',[MDC, MDC],[0,300 ],'b--',[MaxDC, MaxDC],[0,300],'b--');
set(kk,'LineWidth',2);

title([char(ETnew(i)), ' s exposure time. MDC = ',num2str(MDC), ' ng/ml', ', and your MaxDC is ', num2str(MaxDC),' ng/ml.' ],'Fontsize',14);
xlabel('Concentration of Drug (ng/ml)','Fontsize',12)
ylabel('Signal Intensity (a.u.) ','Fontsize',12)
mom(i,:) = resid;

legend ('5 parameter','my 4 parameter','data','location','best');
Fitdataresid(i)=sum(mom(i,:));


yyy2i=[find(255>yyy2(i:i,:))];
yyy2ii=[find(yyy2(i:i,1:max(yyy2i))>1.05*min(yyy2(i:i,:)))];
dx2=max(xxx(yyy2ii))- min(xxx(yyy2ii));
dy2=max(yyy2(yyy2ii))- min(yyy2(yyy2ii));
%range2x(i)=dx2;
%range2y(i)=dy2;
%rr2(i,1)=dx2*dy2;
% [a,b,c]=find(yyy(i:i,:)>1.05*min(yyy(i:i,:)));
% [d,e,f]=find(yyy(i:i,:)<250);
%currenty(i)= yyy(i:i,min(b));
%currentx(i)=[ xxx(min(b))];
%currentymax(i)=[ yyy(i:i,max(e))];
%currentxmax(i)=[ xxx(max(e))];
legend ('5 parameter SD Weights','4 parameter','Known Data','location','Best');
end

toc
set(figure(1), 'paperunits', 'inches', 'paperposition', [0 0 18 15])
print(figure(1),'-dtiff','-r300', 'C:\Documents and Settings\carevalos\Desktop\McDevitt Lab\Data Anyalsis Program\Dia\Dia known.tif')
mom;
 pp=-1;
i=numberofexposures;
c=input('Enter the number of unknowns to test ');
[unkbm]=newdatacompiler(numberofexposures,c,ETnew);

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
max(yarray1)-3*max(sdarray1);
%unk = input('Enter Unknown Intensity ');
%sd = input('Enter Unknown SD ');
%FTU = input('Choose Fit to Use ');
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
 unk
 maximum=CMILP(i)-3*cSD
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
 %figure(3);
 aa=Fitdata{i};
 %semilogx(xxx,aa(xxx));
%xlsPasteTo('Data.xlsx','Sheet1',1000, 1000,'A1')
 yarray1=ymatrix(i,1:noc)'; 
 xarray1;
 sdarray1=sdmatrix(i,1:noc)';
 MDCc=MDCM(i);
MaxDCc=MaxDCM(i);
[unkconc]=unknownfinderdia(Fitdata{i},Fitdata2{i},unk,sd,ETnew(i),xarray1,yarray1,sdarray1,p+1,CMILP(i),CSDLP(i),h,MDCc,MaxDCc); 

 
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
%unk = input('Enter name of file');
%xlswrite('Data.xlsx',FDGmatrix1,'Sheet3','A1')
%xlswrite('Data.xlsx',FDGmatrix2,'Sheet3','B1')
%xlsPasteTo('Data.xlsx','Sheet2',1000, 1000,'A2')
