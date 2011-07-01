%passdir = uigetdir('C:\Users\Ben\Documents\My Dropbox\Cell Phone Project\Images\10_22_2010');
if(ispc)
    passdir = 'Z:\Co-workers\Undergraduates\Tina\Assays\06_15_2011\run 4_10 ng';
elseif(ismac)
    passdir = '/Users/Ben/Dropbox/Colorimetric PSA Detection/Assays/06_28_2011/run 2_10 ng';
else
    disp('Not a mac or a PC WTF')
end
returndir = pwd;
%passdir = uigetdir;
runname = passdir(end-4:end);

number_tests = 3;
tb1 = [2 3 4 5 ];
tb2 = [7 8 9 10];
tb3 = [12 13 14 15];
cb1 = [11 16 17 18 19];
cb2 = cb1;
cb3 = cb1;
run = Tina_Analysis(passdir, number_tests, tb1, cb1, tb2, cb2, tb3, cb3);
save([passdir '/' runname '.mat'], 'run');
clear run;
testnames = {'M167', 'P20C', '5G6'};
Tina_Single_Run_Analysis(testnames, runname, passdir);
cd(returndir);
