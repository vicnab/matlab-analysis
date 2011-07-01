%passdir = uigetdir('C:\Users\Ben\Documents\My Dropbox\Cell Phone Project\Images\10_22_2010');
if(ispc)
    passdir = 'C:\Users\benjamingrantdu\Desktop\sample test' ;
elseif(ismac)
    passdir = '/Users/Ben/Dropbox/Colorimetric PSA Detection/Assays/06_28_2011/run 2_10 ng';
else
    disp('Not a mac or a PC WTF')
end
returndir = pwd;
%passdir = uigetdir;
runname = passdir(end-4:end);

number_tests = 3;
tb1 = [2 3 4 5];
tb2 = [7 8 9 10];
tb3 = [12 13 14 15];
cb1 = [11 16 17 18 19];
cb2 = cb1;
cb3 = cb1;
run = Tina_Analysis(passdir, number_tests, tb1, cb1, tb2, cb2, tb3, cb3);
save([passdir '/' runname '.mat'], 'run');
clear run;
testnames = {'P20C', 'A06', 'PC80'};
Tina_Single_Run_Analysis(testnames, runname, passdir);
cd(returndir);
