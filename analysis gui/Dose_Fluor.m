function [runname direct] = Dose_Fluor(hObject, test, cont);
%% This function is long but limited in its utility. First, it determines
%% the number of concentrations and exposures at each concentration. This
%% takes so many lines of code because the code is intended to be flexible.
%% The exposure and concentration can be listed anywhere in the title of
%% the file. the exposure must be in ms with the number of ms followed by
%% the letters 'ms'. For instance 480ms. It can go up to 9,999 ms (I cannot
%% imagine us doing more than this). The concentration can be followed
%% similarly by the units of concentration which may only be mg, ug, ng or
%% pg.  If you need expanded compatability see me or just list list your
%% concentrations in the nearest available concentrations.  Up to 4 digits
%% acceptable here as well (.001 to 9999 pg, mg, ug,ng ). It then calls
%% Dose_Color_Analysis.m passing the image names for all exposures at a
%% given concentration.  It does this for each concentration, and gets the
%% red,blue,green and gray data and stores them in a matrix.  It then
%% writes the data to an excel sheet and produces a dose response curve for
%% each concentration.  
[num_test samples] = size(test);
curdirect = pwd;
if(ispc)
    direct = uigetdir('C:\Users\Benjamingrantdu\Documents\My Dropbox\Cell Phone Project\Images\10_22_2010');
elseif(ismac)
    direct = uigetdir('/Users/Ben/Dropbox/Cell Phone Project/luanyi data/Images for Ben/Dose Response/Fitz cTnI Stndrd (once freeze-thawed) - 15 ng per ml/');
else
    disp('Not a mac or a PC ?????')
end
handles = guidata(hObject);


cd(direct);
direct_info = dir;
num_img = 0;
num_conc  =0;
conc_vec = [];
conc_cell = {};
exp_vec = [];
num_exp = 0;
%%%This concentration gets the concentrations in the dose curve. I would
%%%highly recommend NOT trying to understand this code, it's regular
%%%expressions and hurts my head, but it works. It looks for units of
%%%concentration mg through pg and finds the numbers that preceed it as per
%%%instructions in saving your file


%% This first loop finds the conc units (mg, ug, ng or pg) as well as the
%% exact concentrations used. It doesn't find the index for each concentration,
%% that will be done in the next loop
for a = 1:length(direct_info)
    if(isempty(regexp(direct_info(a).name, 'top')))  %% want to exclude any top lit images from analysis
        if(isempty(regexp(direct_info(a).name, 'Run')))  %% Run * files are already analyzed files
            if(~isempty(regexp(direct_info(a).name, '[0-9]')))  %% find images only with exposure time listed
                if(~isempty(regexp(direct_info(a).name, 'ms'))) %% to make sure it's an image file
                    imginfo(num_img+1).name = direct_info(a).name; %%saves file name
                    mg = 0;
                    ug = 0;
                    ng = 0;
                    pg = 0;
                    [concindexbeg concindexend] = regexp(direct_info(a).name, 'mg');
                    if(~isempty(concindexbeg)) %% if it finds mg then units are mg
                        mg = 1;
                        units = 'mg';
                    else
                        [concindexbeg concindexend] = regexp(direct_info(a).name, 'ug'); %no mg try ug
                        if(~isempty(concindexbeg)) %if finds ug, units are micrograms
                            ug = 1;
                            units = 'ug';
                        else
                            [concindexbeg concindexend] = regexp(direct_info(a).name, 'ng');
                            if(~isempty(concindexbeg)) %if finds ng, units are nanograms
                                ng = 1;
                                units = 'ng';
                            else
                                [concindexbeg concindexend] = regexp(direct_info(a).name, 'pg');
                                if(~isempty(concindexbeg)) %if finds pg, units are picograms
                                    pg = 1;
                                    units = 'pg';
                                else
                                    error('Oh no! It appears you are not using mg, ug, ng, pg. Check your file names or contact Ben')
                                end

                            end
                        end
                    end
                    if (mg == 1 || ng == 1 || pg == 1 || ug == 1)
                        num_img = num_img+1;
                        concindexbeg = concindexbeg - 4;
                        if(concindexbeg<1)
                            concindexbeg = 1;
                        end
                        concindexend = concindexbeg+4;
                        
                        subname = direct_info(a).name(concindexbeg:concindexend);
                        concindex = regexp(subname, '[0-9]') + concindexbeg-1; %%finds conc 
                        concindex = min(concindex):max(concindex);
                        conc = str2num(direct_info(a).name(concindex));
                       
                        if(isempty(find(conc_vec == conc)))
                            num_conc = num_conc + 1;
                            conc_vec(num_conc) = conc;
                        end
                         [expindexbeg expindexend] = regexp(direct_info(a).name, 'ms');
                         expindexbeg = expindexbeg - 4;
                     
                        if(expindexbeg<1)
                           expindexbeg = 1;
                        end
                        expindexend = expindexbeg+4;
                        expname = direct_info(a).name(expindexbeg:expindexend);
                        expindex = regexp(expname, '[0-9]') + expindexbeg-1; %%finds exposure indices
                        expindex = min(expindex):max(expindex);
                        expo = str2num(direct_info(a).name(expindex)); %%finds exposure time
                        
                        if(isempty(find(exp_vec == expo)))
                            num_exp = num_exp + 1;
                            exp_vec(num_exp) = expo;
                        end
                    end

                end

            end
        end
    end
end
conc_vec = sort(conc_vec);
exp_vec = sort(exp_vec);
for i = 1:num_conc
    conc_cell{1,i} = conc_vec(i);
    conc_cell{2,i} = [];
end
    
    
for a = 1:length(direct_info)
    if(isempty(regexp(direct_info(a).name, 'top')))  %% want to exclude any top lit images from analysis
        if(isempty(regexp(direct_info(a).name, 'Run')))  %% Run * files are already analyzed files
            if(~isempty(regexp(direct_info(a).name, '[0-9]')))  %% find images only with exposure time listed
                if(~isempty(regexp(direct_info(a).name, 'ms'))) %% to make sure it's an image file
                      [concindexbeg concindexend] = regexp(direct_info(a).name, units);
                      concindexbeg = concindexbeg - 4;
                        if(concindexbeg<1)
                            concindexbeg = 1;
                        end
                        subname = direct_info(a).name(concindexbeg:concindexend);
                        concindex = regexp(subname, '[0-9]') + concindexbeg-1; %%finds exposure time
                        concindex = min(concindex):max(concindex);
                        conc = str2num(direct_info(a).name(concindex));
                        conc_num = find(conc_vec == conc);
                             [expindexbeg expindexend] = regexp(direct_info(a).name, 'ms');
                         expindexbeg = expindexbeg - 4;                   
                        if(expindexbeg<1)
                           expindexbeg = 1;
                        end
                        expindexend = expindexbeg+4;
                        expname = direct_info(a).name(expindexbeg:expindexend);
                        expindex = regexp(expname, '[0-9]') + expindexbeg-1; %%finds exposure indices
                        expindex = min(expindex):max(expindex);
                        expo = str2num(direct_info(a).name(expindex)); %%finds exposure time
                        exp_num = find(exp_vec == expo);
                        conc_cell{exp_num,conc_num} = direct_info(a).name;
                      
                end
            end
        end
    end
end
[num_exp num_conc] = size(conc_cell);
                      
images = {};
everything = {};
cal_exp_num  =  listdlg('PromptString', 'Select an Exposure for Bead Detection', 'ListString', int2str(exp_vec'));
cal_exp = exp_vec(cal_exp_num);
for b = 1:num_conc 
    for c = 1:num_exp
        images{c} = conc_cell(c,b);
    end

    everything{b} = Dose_Fluor_Analysis(hObject, direct, test, cont, images, exp_vec, conc_vec(b), cal_exp, num_test, units);
end

write_data_create_dose_response_function(handles, direct, num_test, num_exp, num_conc, everything, exp_vec, conc_vec);





clear centers


hold off;
clear calimg;

set(handles.pan, 'Visible', 'Off');
%set(handles.axes4, 'Visible', 'Off');
set(handles.axes3, 'Visible', 'On');
axes(handles.axes3);

%clear;


cd(curdirect);




