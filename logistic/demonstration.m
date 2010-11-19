subplot(2,1,1)
a = imread('luanyicp5.png');
imagesc(a);
ax = gca;
set(ax, 'YTickLabel', []);
set(ax, 'XTickLabel', []);
subplot(2,1,2);
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
axis([.1 100 0 30]);
suplabel('Luanyi TNF-\alpha data, CP', 't')
pause;
b = imread('luanyifixed4.png');
subplot(2,1,1);
imagesc(b);
ax = gca;
set(ax, 'YTickLabel', []);
set(ax, 'XTickLabel', []);
subplot(2,1,2);
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
axis([.1 100 0 50])
suplabel('Luanyi TNF-\alpha data, Fixed', 't')
pause;
subplot(2,1,1)
c = imread('luanyilp2.png');
imagesc(c);
a = gca;
set(a, 'YTickLabel', []);
set(a, 'XTickLabel', []);
subplot(2,1,2);
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
axis([.1 100 0 70]);
suplabel('Luanyi TNF-\alpha data, Line Profile', 't');
pause;
subplot(2,1,1)
c = imread('jietheoretical.png');
imagesc(c);
a = gca;
set(a, 'YTickLabel', []);
set(a, 'XTickLabel', []);
subplot(2,1,2);
xtheor = [100
10
1
0.1
0.01
0.001];
ytheor = [973.145
973.145
754.913
196.514
26.366
2.912];
dose_response(xtheor,ytheor);
axis([10^(-4) 10^3 0 1200]);
suplabel('Jie CFD Data', 't');
pause;
subplot(2,1,1)
c = imread('sobecoke.png');
imagesc(c);
a = gca;
set(a, 'YTickLabel', []);
set(a, 'XTickLabel', []);
subplot(2,1,2);
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
%axis([10^(-4) 10^3 0 1200]);
suplabel('Sobe Competition Data', 't');