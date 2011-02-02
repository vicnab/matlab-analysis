function [beta_est mse conc_graph intensity_graph] = dose_response_log4param(conc,intensity,beta0)
% Benjamin Grant, Rice University McDevitt Lab 09/14/2010
% function [beta_est mse conc_graph y_graph] = dose_response_log4param(conc,intensity,beta0)
% conc is the concentrations in original form, not log values and intenisty
% is the corresponding intensity intensity, beta0 is an optional argument
% containing the guesses for the 4 parameters of logistic curve fitting
% using the equation
% intensity = a+b*[(exp(c-d*ln(conc))/(1+exp(c-d*ln(conc))]
% Attempts first to try non competitive binding (assuming beta0 is not given)
% and then attempts to try competetive binding if error is found in try
% statement. Only tries the beta0 parameters supplied if they're given.
if(nargin <2)
    error('Must enter dependent and independent vraiables', 'MESSAGE')
elseif (nargin == 2)
    [a order] = sort(conc);
    intensity = intensity(order);
    conc = conc(order);
    beta1 = intensity(1);
    beta2 = intensity(end) - beta1;
    beta3 = 0; %why?
    beta4 = (intensity(end) - intensity(1))/(conc(end) - conc(1));
    if(beta4<0)
        competition = 1;
    else
        competition  = 0;
    end
    beta0 = [beta1 beta2 beta3 -beta4]; %parameter guess, negative beta0(4) necessarry for noncompetetive fitting
end
options = statset('MaxIter', 100000);
try
    [beta_est,r,J,COVB,mse] = nlinfit(conc,intensity,@log4param, beta0, options);
    noplot = 0;
    
catch ME
    if (nargin == 2)
        disp('problem, getting NAN/inf values with fit, talk to Ben')
        noplot = 1;
    else
        disp('supplied beta0 is not allowing for appropriate curve fitting')
        rethrow(ME); %beta0 given didn't work, throw an error
    end
end

conc_low = log10(min(conc))-1;
conc_high = log10(max(conc))+1;
conc_graph = logspace(conc_low,conc_high,1000);
if(noplot)
    conc_graph = conc_graph(1);
    intensity_graph = intensity(1);
else
    intensity_graph = log4param(beta_est, conc_graph);
end
semilogx(conc,intensity,'r*', 'MarkerSize', 7);
hold on
semilogx(conc_graph,intensity_graph, 'LineWidth', 1);
hold off
xlabel('Log(concentration)', 'FontSize', 14);
ylabel('Intensity', 'FontSize', 14);
if(noplot)
    title('Intensity verus Concentration, no fit found');
else
    if(competition)
        title('Sigmoidal fit to competetive dose response curve', 'FontSize', 14);
    else
        title('Sigmoidal fit to noncompetetive dose response curve', 'FontSize', 14);
    end
    
end