function Tina_Single_Run_Analysis(testnames, runname, rundir) 


colormap(jet);
run = importdata([rundir '/' runname '.mat'], 'run');

fid = fopen([rundir '/' runname '.csv'], 'w');
fprintf(fid, '%s, %s, %s, %s, %s, %s, %s, %s, %s, %s \n', run{1,1}, run{1,2}, run{1,3}, run{1,4}, run{1,5}, run{1,6}, run{1,7}, run{1,8}, run{1,9}, run{1,10});
[conditions categories] = size(run);
for k = 1:length(run{2,2}) %first element that is data
    for j = 2:conditions
        if (mod(j,2) == 0)
            conditionname = testnames{j/2};
        else
            conditionname = [testnames{floor(j/2)} ' control'];
        end
        fprintf(fid, '%s, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f\n', conditionname, run{j,2}(k), run{j,3}(k), run{j,4}(k), run{j,5}(k), run{j,6}(k), run{j,7}(k), run{j,8}(k), run{j,9}(k), run{j,10}(k));
        if j == conditions
            fprintf(fid,'\n');
        end
    end
    
end
fid = fopen([rundir '/' runname '_summary.csv'], 'w');
for k = 1:length(run{2,2}) %first element that is data
    fprintf(fid, 'Summary at %4.0f ms Exposure \n', run{j,2}(k))
    fprintf(fid, 'Exposure, Percent CV, Test:Control Ratio \n');
    for j = 2:conditions
       if (mod(j,2) == 0)
            conditionname = testnames{j/2};
        else
            conditionname = [testnames{floor(j/2)} ' control'];
        end
    end
    
end



numtest = (conditions - 1)/2;
fclose(fid);
mycolors = [135.0000/255         0         0;
    0.4392    0.4392    0.4392];

  
for l = 1:length(run{2,2})


    for k = 3:2:categories
        meanmat = [];
        stdmat = [];
        xlab = {};
        for m = 2:2:conditions
            meanmat = [meanmat; run{m,k}(l), run{m+1,k}(l)] ;
            stdmat = [stdmat; run{m,k+1}(l), run{m+1,k+1}(l)];
            
            xlab = [xlab run{m,1}];
        end
        meanvec = meanmat';
        stdvec = stdmat';
        meanvec = meanvec(:);
        stdvec = stdvec(:);
        for refind = 1:2:numel(meanmat)
            xval(refind) = ceil(refind/2) - .15;
            xval(refind+1) = ceil(refind/2)+.15;
        end
         
          
        subnum = floor(k/2);
      
        subplot(2,2,subnum);
       
      
       
         if(numtest == 1)
            meanmat = [meanmat; [0 0]];
         end
         
          h = bar(meanmat);
           
            hold on;
      errorbar(xval,meanvec,stdvec, 'ko')
        hold off;
       
        stringtitle = run{1,k};
        pat = '(?<color>\w+)\s+(?<variable>\w+)\s+(?<meanstd>\w+)';
        wordindex = regexp(stringtitle, pat, 'names');
        a = sprintf('%s Average Median Intensity at %3.0f ms Exposure', wordindex.color, run{2,2}(l));
        title(a);
              a = axis;
        xmin = .5;
        xmax = numtest + .5;
        ymin = 0;
        if (subnum == 4)
            ymax = 550;
        else
            ymax = 300;
        end
        axis([xmin xmax ymin ymax]);
        %scales y a little bigger than default to make room for the legend!
        set(gca,'XTick', [1:numtest]);
        set(gca, 'XTickLabel', testnames)
        if (subnum == 4)
            legend('Positive', 'Control');
        end

        
    end
   
    chkdir = sprintf('%s/Line_Method',rundir);
    if(~isdir(chkdir))
        mkdir(chkdir);
    end
    saveas (gcf, sprintf('%s/%s/%s_%2.0fms.fig',rundir, 'Line_Method',runname,  run{2,2}(l)));
    pause(.5);
end
