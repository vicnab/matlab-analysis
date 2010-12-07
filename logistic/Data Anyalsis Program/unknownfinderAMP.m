function [unk]=unknownfinder(fit,fit2,y,sd,ETT,xarray1,yarray1,sdarray1,p,CMILP,CSDLP,h)

h(p)=figure (p);
warning=0;

xxx=logspace(log10(min(xarray1)),log10(max(xarray1)),1000);


yy=fit(xxx);

yy2=fit2(xxx);
if y<min(yy)
    %y=min(yy);
    disp('warning unknown intensity is below interpolation stage')
end
sdarray1;
[m,n]=size(sdarray1);


% minimum=min(yy)+3*sdarray1(1);
% maximum=254-3*sdarray1(5);
 [a,b,c]=find(y+2*sd/3>yy&yy>y-2*sd/3);
 
 
% [a2,b2,c2]=find(yy<maximum);
% [a1,b1,c1]=find(yy<minimum);
% 
% MDC = xxx(max(a1));
% MaxDC =xxx(max(a2));

% minimum=min(yarray1)+3*sdarray1(m);
% maximum=CMILP-3*CSDLP;
% % MaxDC=maximum;
% % MDC=minimum;
%  [a1,b1,c1]=find(yy>minimum);
%  [a2,b2,c2]=find(yy<maximum);
%  MDC = xxx(max(a1));
%  MaxDC = xxx(max(a2));

 
 minimum=CMILP-3*CSDLP;
maximum=min(yarray1)+max(sdarray1);

MaxDC=max(xarray1);

MDC=min(xarray1);
[a1,b1,c1]=find(yy>minimum);
[a2,b2,c2]=find(yy<maximum);


if max(yy)<minimum
    MDC=min(xarray1);
else
    MDC = xxx(max(a1));
end
if min(yy)>maximum
    MaxDC=max(xarray1);
else
    MaxDC = xxx(min(a2));
end
%MDCM(i)=MDC;
%MaxDCM(i)=MaxDC
 
 
unk=xxx(a);
if y>max(yy)
    disp('warning unknown intensity is above max of interpolation stage, given value is a maximum')
    warning=1;
    [unk,a]=max(yy);
end


kk=semilogx(xxx,fit(xxx),xxx,fit2(xxx),xxx(a),yy(a),'bx',xarray1,yarray1,'ks',median(xxx(a)),median(yy(a)),'ro',[MDC, MDC],[-100,300 ],'b--',[MaxDC, MaxDC],[-100,300],'b--',[median(xxx(a)), median(xxx(a))],[-100, median(yy(a))],'r--',[min(xarray1), median(xxx(a))],[median(yy(a)), median(yy(a))],'r--')
set(kk,'LineWidth',2);
hh=legend ('5 parameter SD Weights','4 parameter','95% percentile unknown range','Known Data','Unknown Value','location','SouthWest');
set(hh,'FontSize',22);
format short
title(['Your Fit used was from exposure time ', char(ETT),' s. ','The unknown concentration was ', num2str(median(xxx(a))),'ng/ml.  Your MDC was ', num2str(MDC),' ng/ml.'],'FontSize',18)
xlabel('Concentration of Drug (ng/ml)','FontSize',18)
ylabel('Signal Intensity (a.u.)','FontSize',18)
unk=median(xxx(a));
set(figure(p), 'paperunits', 'inches', 'paperposition', [0 0 15 15]);
print(figure(p),'-dtiff','-r300', ['C:\Documents and Settings\carevalos\Desktop\McDevitt Lab\Data Anyalsis Program\AMP\AMPunknown',num2str(p-1),'.tif']);