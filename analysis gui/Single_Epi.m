function [runname direct] = Single_Color(cal_exp, hObject, test, cont);
%% This section of code determines the infromation about the number of
%% images, the image with the highest exposure (used to find the beads) and
%% all the imge filenames and corresponding exposure
[numtest samples] = size(cont);
curdirect = pwd;
if(ispc)
    direct = uigetdir('C:\Users\Benjamingrantdu\Documents\My Dropbox\Cell Phone Project\Images\10_22_2010');
    circlepath = 'C:\Users\Benjamingrantdu\matlab-analysis\circle detect';
    AnalysisPath = 'C:\Users\Benjamingrantdu\matlab-analysis\Analysis_Methods\Line_Profile';

elseif(ismac)
    direct = uigetdir('/Users/Ben/Dropbox/Cell Phone Project/luanyi data/Images for Ben/Dose Response/Fitz cTnI Stndrd (once freeze-thawed) - 15 ng per ml/');
    circlepath = '/Users/Ben/matlab-analysis/circle detect';
    AnalysisPath = '/Users/Ben/matlab-analysis/Analysis_Methods/Line_Profile';
else
    disp('Not a mac or a PC ?????')
end
if(isempty(regexp(path,direct)))
    path(path,direct);
end
if(isempty(regexp(path,circlepath)))
    path(path, circlepath);
end
if(isempty(regexp(path,AnalysisPath)))
    path(path, AnalysisPath)
end
keyboard;
cd(direct);
direct_info = dir;
handles = guidata(hObject);
plothandle = handles.axes3;
large = get(handles.large, 'Value');
small = get(handles.small, 'Value');
if (large)
    ncols = 5;
    nrows = 4; %chip rows and columns
elseif(small)
    ncols = 4;
    nrows = 3;
else
    error('wtf')
end
num_image = 0;
cal_exp_index = 0;
imginfo = struct('name', [], 'exp', []); %% keeps track of every image name and exposure in directory
for a = 1:length(direct_info)
    if(isempty(regexp(direct_info(a).name, 'top')))  %% want to exclude any top lit images from analysis
        if(isempty(regexp(direct_info(a).name, 'Run')))  %% Run * files are already analyzed files
            if(~isempty(regexp(direct_info(a).name, '[0-9]')))  %% find images only with exposure time listed
                if(~isempty(regexp(direct_info(a).name, 'ms'))) %% to make sure it's an image file
                    imginfo(num_image+1).name = direct_info(a).name; %%saves file name
                    [msindexbeg msindexend] = regexp(direct_info(a).name, 'ms');
                    msindexbeg = msindexbeg - 6;
                    if(msindexbeg<1)
                        msindexbeg = 1;
                    end
                    subname = direct_info(a).name(msindexbeg:msindexend);
                    expindex = regexp(subname, '[0-9]') + msindexbeg-1; %%finds exposure time
                    exposure = str2num(direct_info(a).name(expindex));
                    imginfo(num_image+1).exp = exposure;  %%records exposure time
                    num_image = num_image + 1; %%indexes number of images
                end
                
            end
        end
    end
end
[BS order] = sort([imginfo.exp]);

imginfo = imginfo(order);

calfile= imginfo(find([imginfo.exp] == cal_exp)).name;
calimg = imread(calfile);
calimg = calimg(:,:,2);

centers =centers_flour(calimg, ncols, nrows);
centers_cell = cell(num_image,1);
for m = 1:length(centers_cell)
    centers_cell{m} = centers;
end

clear centers


hold off;
clear calimg;

for i = 1:num_image
   % figure(1)
   axes(plothandle);
    centers = centers_cell{i};
    img = imread(imginfo(i).name);
    img = img(:,:,1:3);
    imagesc(img);  axis image;
    xlabel('X Pixels');
    ylabel('Y Pixels');
    title(sprintf('Exposure %2.0f ms', imginfo(i).exp));
    hold on;
    %plot(centers(:,1), centers(:,2), 'g+');
    for k = 1 : size(centers, 1),
        DrawCircle(centers(k,1), centers(k,2), centers(k,3), 32, 'b-', 2);
        
    end
    hold off;
    CentersValid = questdlg('Are the centers acceptable?', 'CentersQuest','Yes', 'No', 'No');
    ApplyWide = 'No';
    while (strcmp(CentersValid,'No'))
        FixAction = questdlg('How would you like to fix?', 'Fix','Delete Circle','Redraw for this Exposure', 'Nevermind They Are Fine', 'Nevermind They Are Fine');
        switch FixAction
            case 'Delete Circle'
               
                rect = getrect;
                xmin =rect(1);
                xmax = rect(1) + rect(3);
                ymin = rect(2);
                ymax = rect(2) + rect(4);
                rowremove = find(centers(:,1)>xmin & centers(:,1) < xmax & centers(:,1) & centers(:,2) > ymin & centers(:,2) <ymax);
                %centers = removerows(centers, rowremove);
               
                    if (length(centers) - length(rowremove)<20)
                        
                        centers = removerows(centers,rowremove);
                        centerswithdeletion = centers;
                        row1 = sortrows(centers(find(centers(:,2)<.3*10^3),:));
                        row2 = sortrows(centers(find(centers(:,2) < .5*10^3 & centers(:,2) > .3*10^3),:));
                        row3 = sortrows(centers(find(centers(:,2) < .7*10^3 & centers(:,2) > .5*10^3),:));
                        row4 = sortrows(centers(find(centers(:,2)>.7*10^3),:));
                        for r =1:4
                            rowname = sprintf('row%1.0f', r);
                            currow= eval(rowname);
                            if (length(currow)<5)
                                exes = currow(:,1);
                                if(min(exes)>300)
                                     x1 = currow(1,1);
                                     x2 = currow(4,1);
                                     y1 = currow(1,2);
                                     y2 = currow(4,2);
                                    xdist = (x2 - x1)/3;
                                    newx = x1 - xdist;
                                    slope = (y2-y1)/(x2-x1);
                                    newy = y1 - slope *xdist;
                                    currow = [[newx,newy]; currow];
                                    eval(sprintf('%s = currow;', rowname'));
                                elseif(max(exes)<850)
                                     x1 = currow(1,1);
                                     x2 = currow(4,1);
                                     y1 = currow(1,2);
                                     y2 = currow(4,2);
                                     xdist = (x2 - x1)/3;
                                     newx = x2 + xdist;
                                     slope = (y2-y1)/(x2-x1);
                                     newy = slope *xdist + y2;
                                     currow = [currow; [newx,newy]];
                                     eval(sprintf('%s = currow;', rowname'));
                                   
                                else
                                    for p = 1:length(currow)-1
                                        missing = 0;
                                        dist = currow(p+1,1) - currow(p,1);
                                        if(dist>225)
                                            missing = p+1;
                                        end
                                        if(missing == 2)
                                            x1 = currow(1,1);
                                            x2 = currow(4,1);
                                            y1 = currow(1,2);
                                            y2 = currow(4,2);
                                            xdist = (x2 - x1)/4;
                                            newx = x1 + xdist;
                                            slope = (y2-y1)/(x2-x1);
                                            newy = y1 + slope*xdist;
                                            currow = [currow(1,:); [newx,newy]; currow(2:end,:)];
                                            eval(sprintf('%s = currow;', rowname'));
                                        elseif(missing == 3)
                                            x1 = currow(1,1);
                                            x2 = currow(4,1);
                                            y1 = currow(1,2);
                                            y2 = currow(4,2);
                                            xdist = (x2 - x1)/4;
                                            newx = x1 + 2*xdist;
                                            slope = (y2-y1)/(x2-x1);
                                            newy = y1 + 2*slope*xdist;
                                           currow = [currow(1:2,:); [newx,newy]; currow(3:4:end,:)];
                                            eval(sprintf('%s = currow;', rowname'));
                                       elseif(missing == 3)
                                            x1 = currow(1,1);
                                            x2 = currow(4,1);
                                            y1 = currow(1,2);
                                            y2 = currow(4,2);
                                            xdist = (x2 - x1)/4;
                                            newx = x1 + 3*xdist;
                                            slope = (y2-y1)/(x2-x1);
                                            newy = y1 + 3*slope*xdist;
                                            currow = [currow; [newx,newy]];
                                            currow = [currow(1:3,:); [newx,newy]; currow(4,:)];
                                            eval(sprintf('%s = currow;', rowname'));
                                        end
                                            
                                    end
                                end
                            end
                        end
                                               
                        centers = [row1;row2;row3;row4];
                        
                        hold on;
                        axes(plothandle); imagesc(img);  axis image;
                        xlabel('X Pixels');
                        ylabel('Y Pixels');
                        title(sprintf('Exposure %2.0f ms', imginfo(i).exp));
                        % plot(oldcenters(:,1), oldcenters(:,2), 'g+');
                        for k = 1 : size(centerswithdeletion, 1),
                            DrawCircle(centerswithdeletion(k,1), centerswithdeletion(k,2), centers(k,3), 32, 'b-', 2);
                        end
                        pause(1);
                        %plot(centers(rowremove,1), centers(rowremove,2), 'g+');
                        
                        
                       for k = 1 : size(centers, 1),
                            DrawCircle(centers(k,1), centers(k,2), centers(k,3), 32, 'b-', 2);
                        end
                        hold off;
                    else
                        centers = removerows(centers, rowremove);
                        axes(plothandle); imagesc(img);  axis image;
                        xlabel('X Pixels');
                        ylabel('Y Pixels');
                        title(sprintf('Exposure %2.0f ms', imginfo(i).exp));
                        hold on;
                        for k = 1 : size(centers, 1),
                            DrawCircle(centers(k,1), centers(k,2), centers(k,3), 32, 'b-', 2);
                        end
                        hold off;
                        
                    end
              
                CentersValid = questdlg('Are the centers acceptable?', 'CentersQuest','Yes', 'No', 'No');
                if(strcmp(CentersValid, 'Yes')&& i<num_image)
                    ApplyWide  = questdlg('Apply these centers to remaining exposures?', 'CentersQuest','Yes', 'No', 'No');
                end
                
                
                
            case 'Redraw for this Exposure'
                newcalimg = img(:,:,1);
                newcalimg = 255/max(max(newcalimg)) * newcalimg;
                [accum, circen, cirrad] = CircularHough_Grd(newcalimg, [8 25], 4,15,1);
                clear accum;
                
                %figure(1); imagesc(accum); axis image;
                %title('Accumulation Array from Circular Hough Transform');
                
                
                row1 = sortrows(circen(find(circen(:,2)<.3*10^3),:));
                row2 = sortrows(circen(find(circen(:,2) < .5*10^3 & circen(:,2) > .3*10^3),:));
                row3 = sortrows(circen(find(circen(:,2) < .7*10^3 & circen(:,2) > .5*10^3),:));
                row4 = sortrows(circen(find(circen(:,2)>.7*10^3),:));
                %%extrapolates missing circles (because calibrator beads are too dark!
                for r =1:4
                    rowname = sprintf('row%1.0f', r);
                    if (length(eval(rowname))<5)
                        minxy = min(eval(rowname));
                        minx = minxy(1);
                        maxxy = max(eval(rowname));
                        maxx = maxxy(1);
                        if(minx>300)
                            extrapcom= sprintf('%s = addpointtorow(%s,1);', rowname, rowname); %%if the first bead is a calibrator bead, this will create circle where line angle dictates it should be
                            eval(extrapcom);
                        end
                        if(maxx<900)
                            extrapcom= sprintf('%s = addpointtorow(%s,5);', rowname, rowname); %%if the first bead is a calibrator bead, this will create circle where line angle dictates it should be
                            eval(extrapcom);
                        end
                    end
                end
                centers = [row1;row2;row3;row4];
                axes(plothandle); imagesc(img);  axis image;
                xlabel('X Pixels');
                ylabel('Y Pixels');
                title(sprintf('Exposure %2.0f ms', imginfo(i).exp));
                hold on;
                %plot(centers(:,1), centers(:,2), 'g+');
                for k = 1 : size(centers, 1),
                    DrawCircle(centers(k,1), centers(k,2), centers(k,3), 32, 'b-', 2);
                    
                end
                hold off;
                CentersValid = questdlg('Are the centers acceptable?', 'CentersQuest','Yes', 'No', 'No');
                if(strcmp(CentersValid, 'Yes') && i<num_image)
                    ApplyWide  = questdlg('Apply these centers to remaining exposures?', 'CentersQuest','Yes', 'No', 'No');
                end
            case 'Nevermind They Are Fine'
                CentersValid = 'Yes';
                ApplyWide = 'No';
        end
    end
    
    centers_cell{i} = centers;
    if (strcmp(ApplyWide, 'Yes'))
        for remainder = i:length(centers_cell)
            centers_cell{remainder} = centers;
        end
    else
        centers_cell{i} = centers;
    end
    
   
end
for i = 1:num_image
    axes(plothandle);
    centers = centers_cell{i};
    img = imread(imginfo(i).name);
    img = img(:,:,1:3);
    axes(plothandle); imagesc(img);  axis image;
    xlabel('X Pixels');
    ylabel('Y Pixels');
    title(sprintf('Exposure %2.0f ms', imginfo(i).exp));
    hold on;
    % plot(centers(:,1), centers(:,2), 'g+');
    for k = 1 : size(centers, 1),
        DrawCircle(centers(k,1), centers(k,2), centers(k,3), 32, 'b-', 2);
        
    end
    hold off;
    pause(.5);
end
data_cell = cell(2*numtest+1,10);
data_cell(1,:) = {'Condition', 'Exposure', 'Red Intensity Mean', 'Red Intensity Std', 'Green Intensity Mean', 'Green Intensity Std', 'Blue Intensity Mean', 'Blue Intensity Std', 'Gray Intensity Mean', 'Gray Intensity Std'};
tic
pracrad = mean(centers(:,3));
numlines =24;
for j = 1:num_image;
    centers = centers_cell{j};
    img = imread(imginfo(j).name);
    grayimg = rgb2gray(img);
    [m n unused] = size(img);
  
    [maximared red_int]=line_prof_averages_and_maxima_color(centers,length(centers), numlines,pracrad, double(img(:,:,1)));
    [maximagreen green_int]=line_prof_averages_and_maxima_color(centers,length(centers), numlines,pracrad, double(img(:,:,2))); 
    [maximablue blue_int]=line_prof_averages_and_maxima_color(centers,length(centers), numlines, pracrad,double(img(:,:,3)));
    [maximagray gray_int]=line_prof_averages_and_maxima_color(centers,length(centers), numlines, pracrad, double(grayimg)); 

    counter = 1;
    for condition = 1:numtest
        counter = counter +1;
        strucname = sprintf('test%1.0f', condition);
        testname = sprintf('tb%1.0f', condition);
        contname = sprintf('cb%1.0f', condition);
        data_cell{counter,1} = sprintf('Test %1.0f', condition);
        data_cell{counter,2} = [data_cell{counter,2} imginfo(j).exp];
        data_cell{counter,3} = [data_cell{counter,3} mean(red_int(test(condition,:)))];
        data_cell{counter,4} = [data_cell{counter,4} std(red_int(test(condition,:)))];
        data_cell{counter,5} = [data_cell{counter,5} mean(green_int(test(condition,:)))];
        data_cell{counter,6} = [data_cell{counter,6} std(green_int(test(condition,:)))];
        data_cell{counter,7} = [data_cell{counter,7} mean(blue_int(test(condition,:)))];
        data_cell{counter,8} = [data_cell{counter,8} std(blue_int(test(condition,:)))];
        data_cell{counter,9} = [data_cell{counter,9} mean(gray_int(test(condition,:)))];
        data_cell{counter,10} = [data_cell{counter,10} std(gray_int(test(condition,:)))];
        counter = counter+1;
        data_cell{counter,1} = sprintf('Control %1.0f', condition);
        data_cell{counter,2} = [data_cell{counter,2} imginfo(j).exp] ;
        data_cell{counter,3} = [data_cell{counter,3} mean(red_int(cont(condition,:)))];
        data_cell{counter,4} = [data_cell{counter,4} std(red_int(cont(condition,:)))];
        data_cell{counter,5} = [data_cell{counter,5} mean(green_int(cont(condition,:)))];
        data_cell{counter,6} = [data_cell{counter,6} std(green_int(cont(condition,:)))];
        data_cell{counter,7} = [data_cell{counter,7} mean(blue_int(cont(condition,:)))];
        data_cell{counter,8} = [data_cell{counter,8} std(blue_int(cont(condition,:)))];
        data_cell{counter,9} = [data_cell{counter,9} mean(gray_int(cont(condition,:)))];
        data_cell{counter,10} = [data_cell{counter,10} std(gray_int(cont(condition,:)))];
    end
end
runname = direct(end-4:end);
run = data_cell;
if(ismac)
    save([direct '/' runname '.mat'], 'run');
elseif(ispc)
   save([direct '\' runname '.mat'], 'run');
end
clear data_cell;



%clear;


cd(curdirect);




