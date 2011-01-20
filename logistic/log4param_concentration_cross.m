function [intensity_shift] = log4param_concentration_cross(beta,int_exp,conc)
% Benjamin Grant, Rice University McDevitt Lab 09/14/2010
% function [intensity_shift] = log4param(beta,int_shift,conc) 
% The parameters passed are the beta paramters for 4 parameter logrithmic
% curve, the intenisty of interest, and the concentration range
% this function plots the intenisty utilizing parameters 
% passed to this function. These parameters should be found utilizing 
% the function dose_response. This particular function's purpose is to
% accept an additional parameter, a recorded experimental intensity, and to 
% subtract the intensity plot by this intensity. The point of this is to
% allow for fzero to determine the 0 with this shift, thus finding the
% concentration corresponding to the recorded intensity.  It's output in
% and of itself is not interesting. 
% intenisty_shift = a+b*(exp(c-d*log(conc)))./(1+exp(c - d*log(conc)));
a = beta(1);
b = beta(2);
c = beta(3);
d = beta(4);
intensity_shift = a+b*(exp(c-d*log(conc)))./(1+exp(c - d*log(conc)));
intensity_shift = intensity_shift - int_exp;