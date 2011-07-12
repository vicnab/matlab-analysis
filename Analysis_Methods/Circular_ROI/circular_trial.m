calimg = imread('/Users/Ben/Desktop/Kathleen/calibrators/07_08_2011/run1_ cals_negatives/469ms.tif');
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
avgvalues = [];
beadavgs = [];
beadmins = [];
% [m n]  = size(centers);
% if (n > 2)
%        centers = centers(:,1:2);
%       end
%  [y me] =  circular_ROI_cversion(centers, 12, meanrad, calimgred);
% for beads = 1:ncols*nrows
%     counter = 0;
%     for k = 6:2:floor(meanrad)-2
%         counter = counter + 1;
%         for x = 1:xmax
%             for y= 1:ymax
%                 dist = ((x - centers(beads,1))^2 + (y-centers(beads,2))^2)^(1/2);
%                 if (dist<meanrad-k+2 & dist > meanrad-k)
%                     avgvalues(counter) = calimgred(y,x);
%                     beadavgs(beads, counter) = calimgred(y,x);
%                     beadmins(beads) = min(avgvalues);
%                     calimgred2(y,x) = 255;
%                 else
%                 calimgred2(y,x) = 0;
%             end
%         end
%     end
%     end
% end
% figure;
for beads = 1:1
    counter = 0;
    for k = 6:2:floor(meanrad)-2
        numpts = 0;
        sum = 0;
        counter = counter + 1;
        for x = 1:xmax
            for y= 1:ymax
                dist = ((x - centers(beads,1))^2 + (y-centers(beads,2))^2)^(1/2);
                if (dist<meanrad-k+2 & dist > meanrad-k)
                    numpts = numpts+1;
                    calimgred(y,x);
                    sum = double(sum) + double(calimgred(y,x));
                    calimgred2(y,x) = 255;
                end


            end
        end

        avgvalues(counter) = sum/(numpts);
        beadavgs(beads, counter) = sum/(numpts);

    end
    beadmins(beads) = min(avgvalues);
end
figure;
