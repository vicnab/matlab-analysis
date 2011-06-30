%passdir = uigetdir('C:\Users\Ben\Documents\My Dropbox\Cell Phone Project\Images\10_22_2010');
if(ispc)
    passdir = 'C:\Users\benjamingrantdu\Desktop\sample test' ;
elseif(ismac)
    passdir = '/Users/Ben/Dropbox/Cell Phone Project/Images/10_22_2010/Run 5';
else
    disp('Not a mac or a PC WTF')
end
runname = passdir(end-4:end);
tb1 = [1 6 20];
tb2 = [2 3 4 5 ];
cb1 = [11 16];
cb2 = cb1;
run = Tina_Analysis(passdir, 2, tb1, cb1, tb2, cb2);
save([passdir '/' runname '.mat'], 'run');
clear run;
Tina_Single_Run_Analysis(runname, passdir);
