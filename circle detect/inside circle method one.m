img = imread('~/garbage.tiff');
tic
[rows cols colors] = size(img);
centers = [105 96];
pracrad = 20;
xind = [];
yind = [];
for x = 1:cols
    for y = 1:rows
        dist = (x-centers(vals,1))^2 + (y-centers(vals,2))^2;

        if(dist<pracrad^2)
            xind = [x vals; xind];
            yind = [y vals; yind];
        end
    end
end
