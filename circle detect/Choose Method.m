%passdir = uigetdir('C:\Users\Ben\Documents\My Dropbox\Cell Phone Project\Images\10_22_2010');
if(ispc)
    passdir = uigetdir('C:\Users\Ben\Documents\My Dropbox\Cell Phone Project\Images\10_22_2010');

elseif(ismac)
    passdir = uigetdir('/Users/Ben/Dropbox/Cell Phone Project/Images/11_05_2010/');
else
    disp('Not a mac or a PC WTF')
end
runname = passdir(end-4:end);
tb1 = [2 3 4];
tb2 = [7 8 9];
tb3 = [12 13 14];
tb4 = [17 18 19];
cb1 = [5 10 15];
cb2 = [6 11 16];
cb4 = cb2;
cb3=cb2;

run = Analyze_Bead_Choose_Method(passdir, 4, tb1, cb1, tb2, cb2, tb3, cb3, tb4, cb4);
save([passdir '/' runname '.mat'], 'run');
clear run;
Single_Run_Analysis(runname, passdir);
