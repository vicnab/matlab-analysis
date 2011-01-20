x = [100 10 1 0.1 0.01 0.001]';
y = [973.145 973.145 754.913 196.514 26.366 2.912]';
beta0 = [1000 1 1 1]; %parameter guess
options = statset('MaxIter', 100000)
[beta_est,r,J,COVB,mse] = nlinfit(log(x),y,@sigmoidfun, beta0, options);
x_graph = logspace(-4,4,1000);
y_graph = sigmoidfun(beta_est, log(x_graph));
semilogx(x,y,'*');
hold on
semilogx(x_graph,y_graph);
xlabel('Log(concentration)');
ylabel('Intensity');
title('Sigmoidal fit to dose response curve');
