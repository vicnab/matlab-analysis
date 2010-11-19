function [fresult,gof,output,yy,resid,fresult2,gof2,output2,fresult3,gof3,output3]=powerfit(xvalues,yvaluesarray)


x=xvalues';
y=yvaluesarray;

mymodel = fittype('255/(exp(-b*(x-c))+e)^g');
%mymodel = fittype('A+(255/(1+(x/C)^B)^E)');
%mymodel2 = fittype('255+(a-255)/((1+(x/c)^b)^g)');
mymodel2=fittype('exp(log(exp(log((a-255)/(x-255))/g)-1)/b)*c');
mymodel3 = fittype('255+(a-255)/((1+(x/c)^b))');
opts = fitoptions(mymodel);
opts2 = fitoptions(mymodel2);
opts3 = fitoptions(mymodel3);

set(opts,'normalize','on','MaxIter',1*10^8,'maxfunevals',20000,'Startpoint',[min(yvaluesarray) 0 1 .845 ],'Weights',[20 1 1 1 1 .5 .5 .5]);
%options = fitoptions('normalize','on');
%set(options);
[fresult,gof,output] = fit(x,y,mymodel,opts);
%[fresult,gof,output] = fit(x,y,mymodel,options)

set(opts2,'normalize','off','MaxIter',1*10^8,'MaxFunevals',1000000,'Startpoint',[min(yvaluesarray) 1 1 1 ],'Upper',[inf inf inf inf ]);
set(opts3,'normalize','off','MaxIter',1*10^8,'MaxFunevals',1000000,'Startpoint',[min(yvaluesarray) 1 1 ],'Lower',[1 1 0 ]);
[fresult2,gof2,output2] = fit(x,y,mymodel2,opts2);
[fresult3,gof3,output3] = fit(x,y,mymodel3,opts3);


xx=linspace(1,1000000,1000);
%yy=interp1(x,y,xi,'pchip');
%xx=[1:1000000];
yy=fresult(xx);
yy2=fresult2(xx);
yy3=fresult3(xx);

%yy2=fresult(x);
%semilogx(xx,yy2,xx,yy,x,y,'o');
%axis ([1 10^6 0 300]);
%legend ('5 parameter','my 4 parameter','data','location','NorthWest');
residuals=y-fresult(x);
for i=1:size(y)
resid(i)=residuals(i)/y(i);

%semilogx(fresult)
end
resid';