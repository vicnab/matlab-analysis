function [data_cell] = Dose_Flour_Analysis(hObject, direct, test, cont, images, exp_vec, conc, cal_exp, num_test, units);
handles = guidata(hObject);
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
plothandle = handles.axes3;
num_exp = length(exp_vec);
num_image = num_exp;
calfile = images{find(exp_vec == cal_exp)};
calimg = imread(calfile{:});
centers = centers_flour(calimg(:,:,2), ncols, nrows);
centers_cell = cell(num_exp,1);
for m = 1:length(centers_cell)
    centers_cell{m} = centers;
end

for i = 1:num_exp
   % figure(1)
   axes(plothandle);
    centers = centers_cell{i};
    img = images{i};
    img = imread(img{:});
    img = img(:,:,1:3);
    imagesc(img);  axis image;
    xlabel('X Pixels');
    ylabel('Y Pixels');
    title(sprintf('Exposure %2.0f ms, concentration %3.2f %s', exp_vec(i), conc, units));
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
                        axes(plothandle); 
                        imagesc(img);  axis image;
                        xlabel('X Pixels');
                        ylabel('Y Pixels');
                        title(sprintf('Exposure %2.0f ms, concentration %3.2f %s', exp_vec(i), conc, units));
                        
                        for k = 1 : size(centerswithdeletion, 1),
                            DrawCircle(centerswithdeletion(k,1), centerswithdeletion(k,2), centers(k,3), 32, 'b-', 2);
                        end
                        pause(1);
                      
                        
                        
                       for k = 1 : size(centers, 1),
                            DrawCircle(centers(k,1), centers(k,2), centers(k,3), 32, 'b-', 2);
                        end
                        hold off;
                    else
                        centers = removerows(centers, rowremove);
                        axes(plothandle); 
                        imagesc(img);  axis image;
                        xlabel('X Pixels');
                        ylabel('Y Pixels');
                        title(sprintf('Exposure %2.0f ms, concentration %3.2f %s', exp_vec(i), conc, units));
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
                axes(plothandle); 
                imagesc(img);  axis image;
                xlabel('X Pixels');
                ylabel('Y Pixels');
                title(sprintf('Exposure %2.0f ms, concentration %3.2f %s', exp_vec(i), conc, units));
                hold on;
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
for i = 1:num_exp
   axes(plothandle);
    centers = centers_cell{i};
    img = images{i};
    img = imread(img{:});
    img = img(:,:,1:3);
    axes(plothandle); 
    imagesc(img);  axis image;
    xlabel('X Pixels');
    ylabel('Y Pixels');
    title(sprintf('Exposure %2.0f ms, concentration %3.2f %s', exp_vec(i), conc, units));
    hold on;
    for k = 1 : size(centers, 1),
        DrawCircle(centers(k,1), centers(k,2), centers(k,3), 32, 'b-', 2);
    end
    hold off;
    pause(.5);
end
data_cell = cell(2*num_test+1,10);
data_cell(1,:) = {'Condition', 'Exposure', 'Red Intensity Mean', 'Red Intensity Std', 'Green Intensity Mean', 'Green Intensity Std', 'Blue Intensity Mean', 'Blue Intensity Std', 'Gray Intensity Mean', 'Gray Intensity Std'};
tic
pracrad = mean(centers(:,3));
numlines =24;
for j = 1:num_exp
    centers = centers_cell{j};
    img = images{i};
    img = imread(img{:});
    img = img(:,:,1:3);
    grayimg = rgb2gray(img);
    [m n unused] = size(img);
  
    [maximared red_int]=line_prof_averages_and_maxima_color(centers,length(centers), numlines,pracrad, double(img(:,:,1)));
    [maximagreen green_int]=line_prof_averages_and_maxima_color(centers,length(centers), numlines,pracrad, double(img(:,:,2))); 
    [maximablue blue_int]=line_prof_averages_and_maxima_color(centers,length(centers), numlines, pracrad,double(img(:,:,3)));
    [maximagray gray_int]=line_prof_averages_and_maxima_color(centers,length(centers), numlines, pracrad, double(grayimg)); 

    counter = 1;
    for condition = 1:num_test
        counter = counter +1;
        strucname = sprintf('test%1.0f', condition);
        testname = sprintf('tb%1.0f', condition);
        contname = sprintf('cb%1.0f', condition);
        data_cell{counter,1} = sprintf('Test %1.0f', condition);
        data_cell{counter,2} = [data_cell{counter,2} exp_vec(j)];
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
        data_cell{counter,2} = [data_cell{counter,2} exp_vec(j)] ;
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


