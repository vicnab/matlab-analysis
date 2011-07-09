%passdir = uigetdir('C:\Users\Ben\Documents\My Dropbox\Cell Phone Project\Images\10_22_2010');
if(ispc)
    passdir = 'Z:\Co-workers\Undergraduates\Tina\Assays\06_15_2011\run 4_10 ng';
elseif(ismac)
    passdir = '/Users/Ben/Dropbox/colorimetric psa detection/Assays/07_06_2011/run 2_100 ng';
else
    disp('Not a mac or a PC WTF')
end
returndir = pwd;
%passdir = uigetdir;
runname = passdir(end-4:end);

number_tests = 4;
tb1 = [2 3 4  ];
tb2 = [7 8 9  ];
tb3 = [12 13 14 ];
tb4 = [17 18 19];
cb1 = [5 10 11 16];
cb2 = cb1;
cb3 = cb1;
cb4 =cb1;
run = Tina_Analysis(passdir, number_tests, tb1, cb1, tb2, cb2, tb3, cb3,tb4,cb4);
save([passdir '/' runname '.mat'], 'run');
clear run;
testnames = {'M167', 'M165', 'P20C', '5G6'};
Tina_Single_Run_Analysis(testnames, runname, passdir);
cd(returndir);
