function [fresult,gof,output,resid,fresult2,gof2,output2,weightvector]=powerfit4(xvalues,yvaluesarray,sdb)
format long
fresult=1;
gof=1;
output=1;
x=xvalues';
y=yvaluesarray;
weightvector=weightassigner(sdb);
mymodel1 = fittype('v+(a-v)/((1+(x/c)^b)^g)');
mymodel2 = fittype('v+(a-v)/((1+(x/c)^b))');
opts = fitoptions(mymodel1);
opts2 = fitoptions(mymodel2);


set(opts,'normalize','off','MaxIter',1*10^8,'MaxFunevals',100000,'Startpoint',[max(yvaluesarray) 1 1 .845  0],'Lower',[0 0 0 -10 0],'Upper',[inf inf inf inf 255],'Weights',weightvector);
set(opts2,'normalize','off','MaxIter',1*10^8,'MaxFunevals',100000,'Startpoint',[max(yvaluesarray) 1 1 0],'Lower',[0 0 0 0],'Upper',[inf inf inf 255],'Weights',weightvector);

[fresult,gof,output] = fit(x,y,mymodel1,opts);
[fresult2,gof2,output2] = fit(x,y,mymodel2,opts2);


residuals=y-fresult(x);
for i=1:size(y)
resid(i)=residuals(i)/y(i);

end
resid';