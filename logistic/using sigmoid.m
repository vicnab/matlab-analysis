x = [100
10
1
0.1
0.01
0.001];
y = [973.145
973.145
754.913
196.514
26.366
2.912];
beta1 = [1000 1 1 1]; %parameter guess
[beta_est,r,J,COVB,mse] = nlinfit(log(x),y,@sigmoidfun, beta1, options);
x_graph = logspace(-4,4,1000);
y_graph = sigmafun(beta_est, x_graph);
semilogx(x,y,'*');
hold on
semilogy(x_graph,y_graph);
xlabel('Log(concentration)');
ylabel('Intensity');
title('Sigmoidal fit to dose response curve');
