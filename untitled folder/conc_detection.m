direct_info = dir;
imginfo = struct('name', [], 'exp', []); %% keeps track of every image name and exposure in directory
direct_info = dir;
num_image = 0;
cal_exp = 100;
cal_exp_index = 0;
num_conc  =0;
conc_cell = {};
conc_vec = [];
imgindex = [];
%%%This concentration gets the concentrations in the dose curve. I would
%%%highly recommend NOT trying to understand this code, it's regular
%%%expressions and hurts my head, but it works. It looks for units of
%%%concentration mg through pg and finds the numbers that preceed it as per
%%%instructions in saving your file
for a = 1:length(direct_info)

    if(isempty(regexp(direct_info(a).name, 'top')))  %% want to exclude any top lit images from analysis

        if(isempty(regexp(direct_info(a).name, 'Run')))  %% Run * files are already analyzed files
            if(~isempty(regexp(direct_info(a).name, '[0-9]')))  %% find images only with exposure time listed
                if(~isempty(regexp(direct_info(a).name, 'ms'))) %% to make sure it's an image file
                    imginfo(num_image+1).name = direct_info(a).name; %%saves file name
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
                                    error('Oh no it appears you are not using mg, ug, ng, pg. Check your file names or contact Ben')
                                end

                            end
                        end
                    end
                    if (mg == 1 || ng == 1 || pg == 1 || ug == 1)
                        imgindex = [imgindex; a];

                        concindexbeg = concindexbeg - 4;
                        if(concindexbeg<1)
                            concindexbeg = 1;
                        end
                        subname = direct_info(a).name(concindexbeg:concindexend);
                        concindex = regexp(subname, '[0-9]') + concindexbeg-1; %%finds exposure time
                        concindex = min(concindex):max(concindex);
                        conc = str2num(direct_info(a).name(concindex));
                        if(isempty(find(conc_vec == conc)))
                            num_conc = num_conc  + 1;
                            conc_vec(num_conc) = conc;
                            conc_cell{1,num_conc} = conc;
                        end
                    end

                end

            end
        end
    end
end
for k = imgindex
end