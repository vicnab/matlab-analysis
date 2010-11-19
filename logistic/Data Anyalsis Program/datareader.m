function [I_Lp,Sd_Lp,CV_Lp,I_C,Sd_C,CV_C]= datareader(a)
%r=0;
x=0;
%a;
% Open Data File
%fclose('all')
fid = fopen(a);
fopen('all');

% Loop through data file until we get a -1 indicating EOF
%while(x~=(-1))
%x=fgetl(fid);
%r=r+1
%end
%r = r
%currently causing an error ommitted and line count assumed to be 10



for i = 1:20
    
name = fscanf(fid,'%s',1); % Filter out string at beginning of line
num = fscanf(fid,'%f\n')';% Read in numbers
if(i==1)
    
names = name; % Add 1st text string
result = num; % Add 1st row
else
names = str2mat(names,name); % Add next string
result = [result;num];% Add additional rows
end
end
frewind(fid);
fclose(fid);

I_Lp=result(3,1);
Sd_Lp=result(3,2);
CV_Lp=result(3,3);
I_C=result(3,4);
Sd_C=result(3,5);
CV_C=result(3,6);
