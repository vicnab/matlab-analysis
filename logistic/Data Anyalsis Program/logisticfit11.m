function logisticfit

mymodel = fittype('255*exp(-r(x-t))+1');
opts = fitoptions(mymodel);
set(opts,'normalize','on')
[fit4,gof4,out4] = fit(xarray,yarray,mymodel,opts,);