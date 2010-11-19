%passdir = uigetdir('C:\Users\Ben\Documents\My Dropbox\Cell Phone Project\Images\10_22_2010');
if(ispc)
    passdir = 'C:\Users\Ben\Documents\My Dropbox\Cell Phone Project\Images\11_04_2010\run 3\here' ;
elseif(ismac)
    passdir = '/Users/Ben/Dropbox/Cell Phone Project/Images/10_22_2010/Run 5';
else
    disp('Not a mac or a PC WTF')
end
runname = passdir(end-4:end);
tb1 = [3 8 13 18];
tb2 = [2 4 7 9 12 14 17 19 ];
cb1 = [1 5 6 10 11 15 16 20 ];
cb2 = cb1;

run = Analyze_Beads_Revision2(passdir, 2, tb1, cb1, tb2, cb2);
save([passdir '/' runname '.mat'], 'run');
clear run;
Single_Run_Analysis(runname, passdir);
