function conc = find_intensity_log4param(beta, conc_min, conc_max, intensity)
% Benjamin Grant, Rice University McDevitt Lab 09/14/2010                  
%function conc = find_intensity_log4param(beta, conc_min, conc_max, intensity)
% this function finds the corresponding concentration to a given intensity
% based upon a defined 4 parameter logistic curve. beta are simply the
% parameters defining the curve, conc_min is the minimium concentration
% that this intensity could reasonably correspond to and conc_max is the
% maximum. Don't have these values cut it close, give a broad range within
% the interpolation limits of your data (minimumn concentration and maximum
% you've taken measurements for, not counting zero). intensity is the
% intensity that you're interetested in. Intensity can be a vector of
% multiple intensities of interest if you want, and corresponding
% concentrations will be output in a vector as well
conc_range = [conc_min conc_max];
for i = 1:length(intensity)
    conc(i) = fzero(@(x) log4param_concentration_cross(beta, intensity(i),x),conc_range);
end
