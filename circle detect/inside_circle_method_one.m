clear
tic
img = imread('~/desktop/garbage.tiff'); % load some stupid image
[rows cols colors] = size(img); % find dimensions
clear img % clear it to speed up next section
centers = [100 100]; % center of circle
pracrad = 20; %radius of circle
xind = []; %initialize
yind = [];
for x = 1:cols
    for y = 1:rows
        dist = (x-centers(1))^2 + (y-centers(2))^2;
        dist = dist^(1/2);
        if(dist<=pracrad) %euclidean distance
            xind = [x; xind];
            yind = [y; yind];
        end
    end
end
toc
img = imread('~/desktop/garbage.tiff'); %reload image


img(yind,xind, :) = 255; %make circular area white
imshow(img); %show it