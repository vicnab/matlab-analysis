function meanvalues = AnalyzeBeads(direct, numtest, tb1,cb1,tb2,cb2,tb3,cb3,tb4,cb4,tb5,cb5);
%% This section of code determines the infromation about the number of
%% images, the image with the highest exposure (used to find the beads) and
%% all the imge filenames and corresponding exposure
curdirect = pwd;
path(path,direct);
cd(direct);
imginfo = struct('name', [], 'exp', []); %% keeps track of every image name and exposure in directory
direct_info = dir;
num_image = 0;
cal_exp = 188;
cal_exp_index = 0;
for a = 1:length(direct_info)
    if(isempty(regexp(direct_info(a).name, 'top')))  %% want to exclude any top lit images from analysis
        if(~isempty(regexp(direct_info(a).name, '[0-9]')))  %% find images only with exposure time listed
            if(~isempty(regexp(direct_info(a).name, 'ms'))) %% to make sure it's an image file
                imginfo(num_image+1).name = direct_info(a).name; %%saves file name
                expindex = regexp(direct_info(a).name, '[0-9]'); %%finds exposure time
                exposure = str2num(direct_info(a).name(expindex));
                imginfo(num_image+1).exp = exposure  %%records exposure time
                num_image = num_image + 1; %%indexes number of images
                if(exposure == cal_exp )
                    cal_exp_index = num_image;
                end
            end
        end
    end
end

calfile= imginfo(cal_exp_index).name;
calimg = imread(calfile);
calimg = calimg(:,:,1);
%rawimg = rgb2gray(imgcol(100:800, 1:800, :));
% rawimg = imread('TestImg_CHT_a3.bmp');
%  rawimg = imread('TestImg_CHT_a2.bmp');
path(path,curdirect);
tic;
[accum, circen, cirrad] = CircularHough_Grd(calimg, [8 25], 4,15,1);
clear accum;
toc;
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
pracrad = mean(cirrad)*.8;
figure(1); imagesc(calimg); colormap('gray'); axis image;
centers = [row1;row2;row3;row4];
hold on;
plot(centers(:,1), centers(:,2), 'g+');
for k = 1 : size(centers, 1),
    DrawCircle(centers(k,1), centers(k,2), pracrad, 32, 'b-');
end


title(['Raw Image with Circles Detected ', ...
    '(center positions and radii marked)']);
%figure(3); surf(accum, 'EdgeColor', 'none'); axis ij;
%title('3-D View of the Accumulation Array');
hold off;
clear calimg;
for i = 1:num_image
    figure(i+1)
    img = imread(imginfo(i).name);
    [rows cols colors] = size(img);
    xind = [];
    yind = [];
    for vals = 1:length(centers);
        for x = 1:cols
            for y = 1:rows
                dist = (x-centers(vals,1))^2 + (y-centers(vals,2))^2;
                dist = dist^(1/2);
                if(dist<pracrad)
                    xind = [x vals; xind];
                    yind = [y vals; yind];
                end
            end
        end
    end
    figure(i+1); imagesc(img);  axis image;
    hold on;
    plot(centers(:,1), centers(:,2), 'g+');
    for k = 1 : size(centers, 1),
        DrawCircle(centers(k,1), centers(k,2), pracrad, 32, 'b-');
    end
    hold off;
   


%     red_int = zeros(20,1);
%     green_int = zeros(20,1);
%     blue_int = zeros(20,1);
%     gray_int = zeros(20,1);
%     grayimg = rgb2gray(img);
%     for bead = 1:length(centers)
%         ind_interest = find(xind(:,2)==bead);
%         xindex_interest = xind(ind_interest);
%         yindex_interest = yind(ind_interest);
%         redvals = [];
%         greenvals = [];
%         bluevals = [];
%         grayvals = [];
%         for k = 1:length(xindex_interest)
%             redvals = [img(yindex_interest(k),xindex_interest(k),1); redvals];
%             greenvals = [img(yindex_interest(k),xindex_interest(k),2); greenvals];
%             bluevals = [img(yindex_interest(k),xindex_interest(k),3); bluevals];
%             grayvals = [grayimg(yindex_interest(k),xindex_interest(k)); grayvals];
%         end
%         red_int(bead) = median(redvals);
%         green_int(bead) = median(greenvals);
%         blue_int(bead) = median(bluevals);
%         gray_int(bead) = median(grayvals);
%     end
   
%     for condition = 1:numtest
%         strucname = sprintf('test%1.0f', condition);
%         testname = sprintf('tb%1.0f', condition);
%         contname = sprintf('cb%1.0f', condition);
%         if ( i ==1 & condition == 1)
%              meanvalues = struct();
%             meanvalues.(strucname) = struct('exposure', [], 'RedMedTest',[], 'RedStdTest', [],'GreenMedTest',[], 'GreenStdTest',[], 'BlueMedTest', [],'BlueStdTest',[], 'GrayMedTest',[], 'GrayStdTest',[], 'RedMedCont',[], 'RedStdCont', [],'GreenMedCont',[], 'GreenStdCont',[], 'BlueMedCont', [],'BlueStdCont',[], 'GrayMedCont',[], 'GrayStdCont',[]);
%         end    
%         meanvalues.(strucname)(i).exposure = imginfo(i).exp;
%         meanvalues.(strucname)(i).RedMedTest = mean(red_int(eval(testname)));
%         meanvalues.(strucname)(i).RedStdTest = std(red_int(eval(testname)));
%         meanvalues.(strucname)(i).GreenMedTest = mean(green_int(eval(testname)));
%         meanvalues.(strucname)(i).GreenStdTest = std(green_int(eval(testname)));
%         meanvalues.(strucname)(i).BlueMedTest = mean(blue_int(eval(testname)));
%         meanvalues.(strucname)(i).BlueStdTest = std(blue_int(eval(testname)));
%         meanvalues.(strucname)(i).GrayMedTest = mean(gray_int(eval(testname)));
%         meanvalues.(strucname)(i).GrayStdTest = std(gray_int(eval(testname)));
%         
%         meanvalues.(strucname)(i).RedMedCont = mean(red_int(eval(contname)));
%         meanvalues.(strucname)(i).RedStdCont = std(red_int(eval(contname)));
%         meanvalues.(strucname)(i).GreenMedCont = mean(green_int(eval(contname)));
%         meanvalues.(strucname)(i).GreenStdCont = std(green_int(eval(contname)));
%         meanvalues.(strucname)(i).BlueMedCont = mean(blue_int(eval(contname)));
%         meanvalues.(strucname)(i).BlueStdCont = std(blue_int(eval(contname)));
%         meanvalues.(strucname)(i).GrayMedCont = mean(gray_int(eval(contname)));
%         meanvalues.(strucname)(i).GrayStdCont = std(gray_int(eval(contname)));
%     end
%     clear img;
%     clear grayimg;
% end
% for condition = 1:numtest  %%sort from lowest to highest exposure, sorts all columns based on exposure
%     strucname = sprintf('test%1.0f', condition);
%     [unused, order] = sort([meanvalues.(strucname)(:).exposure]);
%     meanvalues.(strucname) = meanvalues.(strucname)(order);
% end
end

cd(curdirect);




