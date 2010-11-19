function [fresult,gof,output,yy,resid,weightvector]=powerfit(xvalues,yvaluesarray,sdb)
% rangcur=currentxmax-currentx
%%bpprange=fit(ET',log(rangcur)','power1','Weights',[1 1 1 1 1 1 0 1 23])
%%power fit used
tic
fresult=1;
gof=1;
output=1;
x=xvalues';
y=yvaluesarray;
weightvector=weightassigner(sdb);
%mymodel = fittype('255/(exp(-b*(x-c))+e)^g');
%mymodel = fittype('A+(255/(1+(x/C)^B)^E)');
mymodel2 = fittype('v+(a-v)/((1+(x/c)^b)^g)');
%mymodel2=fittype('255+(a-255)/((1+(x/c)^b))^g')
mymodel3 = fittype('v+(a-v)/((1+(x/c)^b))');
opts = fitoptions(mymodel2);
opts2 = fitoptions(mymodel2);
opts3 = fitoptions(mymodel3);

%set(opts,'normalize','on','MaxIter',1*10^6,'maxfunevals',20000,'Startpoint',[min(yvaluesarray) 0 1 .845 ],'Weights',[20 1 1 1 1 .5 .5 .5]);
%options = fitoptions('normalize','on');
%set(options);
%[fresult,gof,output] = fit(x,y,mymodel,opts);
%[fresult,gof,output] = fit(x,y,mymodel,options)
set(opts,'normalize','off','MaxIter',1*10^8,'MaxFunevals',100000,'Startpoint',[min(yvaluesarray) 1 1 .845  1],'Lower',[1 1 0 0 0],'Weights',sdb);
set(opts2,'normalize','off','MaxIter',1*10^8,'MaxFunevals',100000,'Startpoint',[min(yvaluesarray) 1 1 .845 1 ],'Lower',[1 1 0 0 0],'Weights',sdb);
set(opts3,'normalize','off','MaxIter',1*10^8,'MaxFunevals',100000,'Startpoint',[min(yvaluesarray) 1 1 1],'Lower',[0 0 0 0],'Weights',sdb);
[fresult,gof2,output2] = fit(x,y,mymodel2,opts);
[fresult2,gof2,output2] = fit(x,y,mymodel2,opts2);
%[fresult3,gof3,output3] = fit(x,y,mymodel3,opts3);


xx=linspace(1,100000,100000);
%yy=interp1(x,y,xi,'pchip');
%xx=[1:1000000];
yy=fresult2(xx);
yy2=fresult2(xx);
yy3=fresult2(xx);

%yy2=fresult(x);
semilogx(xx,yy2,'x',x,y,'o');
%axis ([1 10^6 0 300]);
%legend ('5 parameter','my 4 parameter','data','location','NorthWest');
residuals=y-fresult2(x);
for i=1:size(y)
resid(i)=residuals(i)/y(i);

%semilogx(fresult)
end
resid';
toc