calimg = imread('Z:\Co-workers\Undergraduates\Kathleen\calibrators\07_08_2011\run1_ cals_negatives\375ms.tif');
calimgred = calimg(:,:,1);
calimgred2 = calimgred;
ncols = 4;
nrows = 3;

[centers meanrad] = colors_kathleen(calimgred, ncols, nrows);
hold on;
for k = 1 : size(centers, 1),
    DrawCircle(centers(k,1), centers(k,2), meanrad, 32, 'y-');
end
[ymax xmax colors] = size(calimg);
for x = 1:xmax
    for y= 1:ymax
        dist = ((x - centers(1,1))^2 + (y-centers(1,2))^2)^(1/2);
        if (dist<25 & dist > 23)
            calimgred2(y,x) = 255;
        else
            calimgred2(y,x) = 0;
        end
    end
end
figure;
imshow(calimgred2);