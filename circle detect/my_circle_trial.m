clear;
imgcol = imread('188 ms.tif');
rawimg = imgcol(:,:,1);
%rawimg = rgb2gray(imgcol(100:800, 1:800, :));
% rawimg = imread('TestImg_CHT_a3.bmp');
%  rawimg = imread('TestImg_CHT_a2.bmp');
tic;
[accum, circen, cirrad] = CircularHough_Grd(rawimg, [8 25], 4,15,1);
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
figure(1); imagesc(rawimg); colormap('gray'); axis image;
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
img60 = imread('60 ms.tif');

%img60 = img60(:,:,1);
[rows cols colors] = size(img60);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% if you want to white out circle areas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for proof of principle

%   for vals = 1:length(centers);
%       for x = 1:cols
%     for y = 1:rows
%     dist = (x-centers(vals,1))^2 + (y-centers(vals,2))^2;
%     dist = dist^(1/2);
%     if(dist<pracrad)
%     img60(y,x,:) = 255;
%     end
%     end
%       end
%   end
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
figure(2); imagesc(img60);  axis image;
hold on;
plot(centers(:,1), centers(:,2), 'g+');
for k = 1 : size(centers, 1),
    DrawCircle(centers(k,1), centers(k,2), pracrad, 32, 'b-');
end
hold off;

red_int = zeros(20,1);
green_int = zeros(20,1);
blue_int = zeros(20,1);
gray_int = zeros(20,1);
grayimg = rgb2gray(img60);
for bead = 1:length(centers)
    vals = [];
    ind_interest = find(xind(:,2)==bead);
    xindex_interest = xind(ind_interest);
    yindex_interest = yind(ind_interest);
    redvals = [];
    greenvals = [];
    bluevals = [];
    grayvals = [];
    for i = 1:length(xindex_interest)
        redvals = [img60(yindex_interest(i),xindex_interest(i),1); redvals];
        greenvals = [img60(yindex_interest(i),xindex_interest(i),2); greenvals];
        bluevals = [img60(yindex_interest(i),xindex_interest(i),3); bluevals];
        grayvals = [grayimg(yindex_interest(i),xindex_interest(i)); grayvals];
    end
    red_int(bead) = median(redvals);
    green_int(bead) = median(greenvals);
    blue_int(bead) = median(bluevals);
    gray_int(bead) = median(grayvals);
end

    

