function Single_Run_Analysis(handles, runname, rundir) 
% if(ispc)
%     passdir = 'C:\Users\Ben\Documents\My Dropbox\Cell Phone Project\Images\10_22_2010\Run 2' ;
% elseif(ismac)
%     passdir = '/Users/Ben/Dropbox/Cell Phone Project/Images/10_22_2010/Run 2';
% else
%     disp('Not a mac or a PC WTF')
% end
set(handles.axes3, 'Visible', 'Off');
cla(handles.axes3);
set(handles.pan, 'Visible', 'On');
%set(handles.axes4, 'Visible', 'On');
colormap(jet);
run = importdata([rundir '/' runname '.mat'], 'run');

fid = fopen([rundir '/' runname '.txt'], 'w');
fprintf(fid, '%s, %s, %s, %s, %s, %s, %s, %s, %s, %s \n', run{1,1}, run{1,2}, run{1,3}, run{1,4}, run{1,5}, run{1,6}, run{1,7}, run{1,8}, run{1,9}, run{1,10});
[conditions categories] = size(run);
for k = 1:length(run{2,2}) %first element that is data
    for j = 2:conditions
        fprintf(fid, '%s, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f\n', run{j,1}, run{j,2}(k), run{j,3}(k), run{j,4}(k), run{j,5}(k), run{j,6}(k), run{j,7}(k), run{j,8}(k), run{j,9}(k), run{j,10}(k));
        if j == conditions
            fprintf(fid,'\n');
        end
    end
end
numtest = (conditions - 1)/2;
fclose(fid);
mycolors = [135.0000/255         0         0;
    0.4392    0.4392    0.4392];
%axes(plothandle);
  
for l = 1:length(run{2,2})
   % figure('visible', 'off');

    for k = 3:2:categories
        meanmat = [];
        stdmat = [];
        xlab = {};
        for m = 2:2:conditions
            meanmat = [meanmat; run{m,k}(l), run{m+1,k}(l)] ;
            stdmat = [stdmat; run{m,k+1}(l), run{m+1,k+1}(l)];
            
            xlab = [xlab run{m,1}];
        end
        %meanmat = meanmat(1,:);
        %stdmat = stdmat(1, :);
        meanvec = meanmat';
        stdvec = stdmat';
        meanvec = meanvec(:);
        stdvec = stdvec(:);
        for refind = 1:2:numel(meanmat)
            xval(refind) = ceil(refind/2) - .15;
            xval(refind+1) = ceil(refind/2)+.15;
        end
         
          
        subnum = floor(k/2);
       %axes(handles.axes4)
        subplot(2,2,subnum,'Parent', handles.pan);
       
      
       
         if(numtest == 1)
            meanmat = [meanmat; [0 0]];
         end
         
          h = bar(meanmat);
           
            hold on;
      errorbar(xval,meanvec,stdvec, 'ko')
        hold off;
        %handles = barweb(barvalues, errors, width, groupnames, bw_title, bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend, error_sides, legend_type)
        stringtitle = run{1,k};
        pat = '(?<color>\w+)\s+(?<variable>\w+)\s+(?<meanstd>\w+)';
        wordindex = regexp(stringtitle, pat, 'names');
        a = sprintf('%s Average Median Intensity at %3.0f ms Exposure', wordindex.color, run{2,2}(l));
        title(a);
        %tic
      %  handles = barweb(meanmat,stdmat, [], [],a,[],run(1,k),mycolors,[],{'test' ;'control'}, [], 'NorthEastOutside');
       % toc
        %set(handles.legend, 'Position', [.6 .39 .04 .04]);
        a = axis;
        xmin = .5;
        xmax = numtest + .5;
        ymin = 0;
        if (subnum == 4)
            ymax = 550
        else
            ymax = 300;
        end
        axis([xmin xmax ymin ymax]);
        %scales y a little bigger than default to make room for the legend!
        set(gca,'XTick', [1:numtest]);
        set(gca, 'XTickLabel', xlab)

        
    end
    %set(gcf,'Position', [1         -17        1280         701]);
    %refresh(gcf);
    %set(gcf, 'Units', 'normalized', 'Position', [0 0 1 1])
    %set(gcf, 'Color', [1 1 1]);
    %filesave=  sprintf('%s/%s/%s_%2.0fms', rundir,'Line_Method', runname, run{2,2}(l));
    %exportcmd = sprintf('%s ''%s'' %s %s %s %s', 'export_fig', filesave, '-tif', '-nocrop', '-q105');
    %eval(exportcmd);
    chkdir = sprintf('%s/Line_Method',rundir);
    if(~isdir(chkdir))
        mkdir(chkdir);
    end
    saveas (gcf, sprintf('%s/%s/%s_%2.0fms.fig',rundir, 'Line_Method',runname,  run{2,2}(l)));
    pause(.5);
  
end
set(handles.pan, 'Visible', 'Off');
%set(handles.axes4, 'Visible', 'Off');
set(handles.axes3, 'Visible', 'On');
axes(handles.axes3);