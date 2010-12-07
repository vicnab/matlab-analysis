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
    beta3 = conc(find(intensity == min(intensity))); 
    beta0 = [1 max(intensity) beta3 -1]; %parameter guess, negative beta0(4) necessarry for noncompetetive fitting
end
options = statset('MaxIter', 100000);
try
    [beta_est,r,J,COVB,mse] = nlinfit(conc,intensity,@log4param, beta0, options);
    competition = 0; 
catch ME
    if (nargin == 2)
            beta3 = conc(find(intensity == max(intensity)));
        beta0 = [min(intensity) max(intensity) beta3 1];
        [beta_est,r,J,COVB,mse] = nlinfit(conc,intensity,@log4param, beta0, options); % parameter guess, positive beta0(4) necessarry for noncompetetive fitting
        competition = 1;
    else
        disp('supplied beta0 is not allowing for appropriate curve fitting')
        rethrow(ME); %beta0 given didn't work, throw an error 
    end
end
    
conc_low = log10(min(conc))-1;
conc_high = log10(max(conc))+1;
conc_graph = logspace(conc_low,conc_high,1000);
intensity_graph = log4param(beta_est, conc_graph);
semilogx(conc,intensity,'*');
hold on
semilogx(conc_graph,intensity_graph);
hold off
xlabel('Log(concentration)');
ylabel('Intensity');
if(competition)
    title('Sigmoidal fit to competetive dose response curve');
else
    title('Sigmoidal fit to noncompetetive dose response curve');
end
    