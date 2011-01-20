function [beta_est x_graph y_graph] = doseresponse(x,y,beta0, vargin)
beta0 = [1 1 1 1000]; %parameter guess
options = statset('MaxIter', 100000);
[beta_est,r,J,COVB,mse] = nlinfit(x,y,@log4alt, beta0, options);
x_graph = logspace(-4,4,1000);
y_graph = sigmoidfun(beta_est, x_graph);
semilogx(x,y,'*');
hold on
semilogx(x_graph,y_graph);
hold off
xlabel('Log(concentration)');
ylabel('Intensity');
title('Sigmoidal fit to dose response curve');
