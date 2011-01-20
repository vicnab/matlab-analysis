function [intensity] = log4param(beta,conc)
% Benjamin Grant, Rice University McDevitt Lab 09/14/2010
% function [intensity] = log4param(beta,conc)                             
% This function is used to produce 4 parameter logistic curves given
% concentration values from a dose response curve and the parameters
% defining the curve, a,b ,c and d given in a vector beta. Raw data should
% be given to dose_response which determines these parameters based on
% intesnity and concentration values recorded in the lab
% concentration = a+b*(exp(c-d*log(conc)))./(1+exp(c - d*log(conc)));
a = beta(1);
b = beta(2);
c = beta(3);
d = beta(4);
intensity = a+b*(exp(c-d*log(conc)))./(1+exp(c - d*log(conc)));