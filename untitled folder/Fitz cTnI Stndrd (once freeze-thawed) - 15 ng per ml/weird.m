direct_info = dir;
num_image = 0;
cal_exp = 380;
cal_exp_index = 0;
imginfo = struct('name', [], 'exp', []); %% keeps track of every image name and exposure in directory
for a = 1:length(direct_info)
    
    if(isempty(regexp(direct_info(a).name, 'top')))  %% want to exclude any top lit images from analysis
        
        if(isempty(regexp(direct_info(a).name, 'Run')))  %% Run * files are already analyzed files
            if(~isempty(regexp(direct_info(a).name, '[0-9]')))  %% find images only with exposure time listed
                if(~isempty(regexp(direct_info(a).name, 'PBS'))) %% to make sure it's an image file
                     if(~isempty(regexp(direct_info(a).name, 'tif'))) %% to make sure it's an image file
                    imginfo(num_image+1).name = direct_info(a).name; %%saves file name
                    explocal = regexp(direct_info(a).name, 'ms');
                    expstring = direct_info(a).name(explocal-4:explocal); 
                    expindex = regexp(expstring, '[0-9]'); %%finds exposure time
                    exposure = str2num(expstring(expindex));
                    imginfo(num_image+1).exp = exposure;  %%records exposure time
                    num_image = num_image + 1; %%indexes number of images
                     end
                end
                
            end
        end
    end
end
[BS order] = sort([imginfo.exp]);

imginfo = imginfo(order);

calfile= imginfo(find([imginfo.exp] == cal_exp)).name;
calimg = imread(calfile);