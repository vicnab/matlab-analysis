function [y] = log4alt(beta,x)

a = beta(1);
b = beta(2);
c = beta(3);
d = beta(4);
y = d + (a-d)./(1+(x/c).^b);