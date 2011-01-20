if(ispc)
    passdir = 'C:\Users\Ben\Documents\My Dropbox\Cell Phone Project\Images\10_22_2010\Run 2' ;
elseif(ismac)
    passdir = '/Users/Ben/Dropbox/Cell Phone Project/Images/10_22_2010/Run 2';
else
    disp('Not a mac or a PC WTF')
end
run = importdata('run1.mat');
fid = fopen('trial_run1.txt', 'w');
fprintf(fid, '%s, %s, %s, %s, %s, %s, %s, %s, %s, %s', run{1,1}, run{1,2}, run1{1,3}, run{1,4}, run{1,5}, run{1,6}, run{1,7}, run{1,8}, run{1,9}, run{1,10});
fprintf(fid, '%2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f', run{2,1}, run{2,2}, run{2,3}, run{1,4}, run{1,5}, run{1,6}, run{1,7}, run{1,8}, run{1,9}, run{1,10});
fclose(fid); 