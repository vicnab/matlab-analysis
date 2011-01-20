function [beta_est mse x_graph y_graph] = dose_response_sigmoidal(x,y,beta0)
%%x is the concentrations in original form, not log values and y is the
%%intensity, beta is an optional argument containing the guesses for the 4
%%parameters of logistic curve fitting using the equation 
%y = yscale./(1+(exp(-k.*(x-xoffset))))+yoffset;
if(nargin <2)
    error('Must enter dependent and independent vraiables', 'MESSAGE')
elseif (nargin == 2)
    beta0 = [1000 1 1 1]; %parameter guess
end
options = statset('MaxIter', 100000);
[beta_est,r,J,COVB,mse] = nlinfit(log(x),y,@sigmoidfun, beta0, options);
xlow = log10(min(x))-1;
xhigh = log10(max(x))+1;
x_graph = logspace(xlow,xhigh,1000);
y_graph = sigmoidfun(beta_est, log(x_graph));
semilogx(x,y,'*');
hold on
semilogx(x_graph,y_graph);
hold off
xlabel('Log(concentration)');
ylabel('Intensity');
title('Sigmoidal fit to dose response curve');
