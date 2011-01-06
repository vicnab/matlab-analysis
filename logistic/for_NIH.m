
xcp5 = [25
12.5
6.25
3.125
1.6
0.8];
ycp5 = [24.02
21.465
14.375
12.48
9.455
8.99];
dose_response(xcp5,ycp5);
axis([.1 100 5 30]);
pause;

xfixed = [25
12.5
6.25
3.125
1.6
0.8];
yfixed = [17.3085
16.3468
11.8939
11.2807
8.9611
8.3151];

dose_response(xfixed,yfixed);
axis([.1 100 7 20])
pause;
xlp = [25
12.5
6.25
3.125
1.6
0.8];
ylp = [61.8503
43.8933
23.2278
17.7174
13.7804
12.9241];

dose_response(xlp,ylp);
set(gca, 'FontSize', 18)
axis([.1 100 7 85]);

pause; 
xtheor = [10000
1000
100
10
1];
ytheor = [64.852
106.6387
150.9831
156.627
155.7086];
dose_response(xtheor,ytheor);
set(gca, 'FontSize', 18)
%axis([10^(-4) 10^3 0 1200]);
