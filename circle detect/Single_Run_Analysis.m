function Single_Run_Analysis(runname, rundir) 
% if(ispc)
%     passdir = 'C:\Users\Ben\Documents\My Dropbox\Cell Phone Project\Images\10_22_2010\Run 2' ;
% elseif(ismac)
%     passdir = '/Users/Ben/Dropbox/Cell Phone Project/Images/10_22_2010/Run 2';
% else
%     disp('Not a mac or a PC WTF')
% end
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
fclose(fid);
mycolors = [135.0000/255         0         0;
    0.4392    0.4392    0.4392];
  
for l = 1:length(run{2,2})
    %figure(l);

    for k = 3:2:categories
        meanmat = [];
        stdmat = [];
        xlab = {};
        for m = 2:2:conditions
            meanmat = [meanmat; run{m,k}(l), run{m+1,k}(l)] ;
            stdmat = [stdmat; run{m,k+1}(l), run{m+1,k+1}(l)];
            xlab = [xlab run{m,1}];
        end
        subnum = floor(k/2);
        subplot(2,2,subnum);
        %handles = barweb(barvalues, errors, width, groupnames, bw_title, bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend, error_sides, legend_type)
        stringtitle = run{1,k};
        pat = '(?<color>\w+)\s+(?<variable>\w+)\s+(?<meanstd>\w+)';
        wordindex = regexp(stringtitle, pat, 'names');
        a = sprintf('%s Average Median Intensity at %3.0f ms Exposure', wordindex.color, run{2,2}(l));
        handles = barweb(meanmat,stdmat, [], [],a,[],run(1,k),mycolors,[],{'test' ;'control'}, [], 'NorthEastOutside');
        set(handles.legend, 'Position', [.6 .39 .04 .04]);
        a = axis;
        a(4) = 1.2 * a(4);
        axis(a); %scales y a little bigger than default to make room for the legend!
        set(handles.ax, 'XTickLabel', xlab)

        if subnum == 1
            set(handles.legend, 'Position', [.15 .87 .04 .04])
        elseif subnum == 2
            set(handles.legend, 'Position', [.6 .87 .04 .04])
        elseif subnum == 3
            set(handles.legend, 'Position', [.15 .39 .04 .04])
        elseif subnum == 4
            set(handles.legend, 'Position', [.6 .39 .04 .04])
        end
        
    end
    %set(gcf,'Position', [1         -17        1280         701]);
    %refresh(gcf);
    set(gcf, 'Units', 'normalized', 'Position', [0 0 1 1])
    set(gcf, 'Color', [1 1 1]);
    filesave=  sprintf('%s/%s_%2.0fms', rundir,runname, run{2,2}(l));
    exportcmd = sprintf('%s ''%s'' %s %s %s %s', 'export_fig', filesave, '-tif', '-nocrop', '-q105');
    eval(exportcmd);
    saveas (gcf, sprintf('%s/%s_%2.0fms.fig',rundir, runname,  run{2,2}(l)));
  
end