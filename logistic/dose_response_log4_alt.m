function [mse beta_est x_graph y_graph] = dose_response_log4_alt(x,y,beta0)
%%x is the concentrations in original form, not log values and y is the
%%intensity, beta is an optional argument containing the guesses for the 4
%%parameters of logistic curve fitting using the equation y = d+(a-d)/[1+(x/c)^b]
if(nargin <2)
    error('Must enter dependent and independent vraiables', 'MESSAGE')
elseif (nargin == 2)
    beta0 = [1 1 1 1000]; %parameter guess
end
options = statset('MaxIter', 100000);
[beta_est,r,J,COVB,mse] = nlinfit(x,y,@log4alt, beta0, options);
xlow = log10(min(x))-1;
xhigh = log10(max(x))+1;
x_graph = logspace(xlow,xhigh,1000);
y_graph = log4alt(beta_est, x_graph);
semilogx(x,y,'*');
hold on
semilogx(x_graph,y_graph);
hold off
xlabel('Log(concentration)');
ylabel('Intensity');
title('Sigmoidal fit to dose response curve');
