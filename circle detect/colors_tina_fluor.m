function centers = centers_flour(calimg, ncols, nrows)
[accum, circen, cirrad] = CircularHough_Grd(calimg, [35  50], 5,15,1);
centers = circen;
centers = [centers cirrad];
[garb sorted] = sort(centers(:,1));
centers = centers(sorted,:);
todelete = [];
[ys xs] = size(calimg);
regdiff = min([ys/6 xs/6]).^2;
for i=1:length(centers)-1
    diffs = (centers(i,1) - centers(i+1,1)).^2 + (centers(i,2) - centers(i+1,2)).^2;
    if (diffs/regdiff < .5)
        todelete = [todelete ; i];
    end
end
if(strcmp(version('-release'), '2010b'))
    centers = removerows(centers,'ind', todelete);
else
    centers = removerows(centers,todelete);
end
%%to find bottom right bead and top left bead ( the two beads the
%%algorithm should ALWAYS be able to find, find the distance of the
%%centers of each bead in terms of the distance from the origin (pixel
%%0,0, top left).  The greatest distance is the bottomright bead, the
%%shortest is the top left. This allows you to determine topleft and
%%bottomright regardless of the slant of the image
distance = centers(:,1).^2 + centers(:,2).^2;
topleft  = centers(find(distance == min(distance)),:);
bottomright = centers(find(distance == max(distance)),:);
a = [ 1 0]; % x unit vector
xdiag = bottomright(1) - topleft(1);
ydiag  = bottomright(2) - topleft(2);
b = [xdiag ydiag]; %vector from top left to bottom right corner
magb = norm(b); %norm function find magnitude of vector
angb = atand(ydiag/xdiag); %angle of this vector b
%ang = atand(4/5) - acosd(dot(a,b)/(norm(a)*norm(b)));
%miny = min(centers(:,2));
bmidx = topleft(1) + magb *cosd(angb)*.5;
bmidy = topleft(2) + magb *sind(angb)*.5;
%this part is tricky. There is a triangle formed by the center of the
%topleft bead, to the midpoint of vector b, to the center of topright
%bead. Now we know that the angle of vector b not relative to our
%coordinate system but relative to the chip is arctan(3/4). Thus, the
%angle coming out of the top right and topleft beads is arctan(3/4) =
%36.9. Then, the angle between vector b, and the vector pointing from
%midpoint of b to topright bead is 180 - 2 * arctan(3/4) = 106.3. So to
%find this vector, you can take the vector pointing from midpoint of B to
%topleft bead and rotate it 106.3 degrees.


%vector pointing from midpoint, lets call it vector c
c = [topleft(1) - bmidx; topleft(2) - bmidy];
%create rotation matrix using form R(theta) = [cos(theta) -sin(theta);
%sin(theta) cos(theta)]'
imgskew = angb - atand((nrows-1)/(ncols-1)); %shows how much chip is rotated relative to image, if perfectly aligned angle o B would be atand((nrows-1)/(ncols-1)), gives clockwise rotation
thetarot = 180 - 2 * atand((nrows-1)/(ncols-1));
rotmat = [cosd(thetarot) -1*sind(thetarot); sind(thetarot) cosd(thetarot)];
%vector d will point from b mid to top right bead
d = rotmat * c;

magd = norm(d);
angd = atand(d(2)/d(1));
topright(1) = bmidx + magd *cosd(angd);
topright(2) = bmidy + magd*sind(angd);

%vector for row, vec R1
R1 = [topright(1) - topleft(1) topright(2) - topleft(2)];
magR1 = norm(R1);
angR1 = atand(R1(2)/R1(1));
B1 = topleft;
R1x = magR1/(ncols-1) * [0:ncols-1] * cosd(angR1) + B1(1);
R1y = magR1/(ncols-1) * [0:ncols-1] * sind(angR1) + B1(2);

B5 = topright;

%vector for columms
C1 = [bottomright(1) - topright(1) bottomright(2) - topright(2)];

magC1 = norm(C1);
angC1 = atand(C1(2)/C1(1));
beadsx = repmat(R1x, nrows, 1);
beadsy = repmat(R1y, nrows, 1);
xadd = [0:nrows-1]' * cosd(angC1) *magC1/(nrows-1);
yadd = [0:nrows-1]' * sind(angC1) *magC1/(nrows-1);
xadd = repmat(xadd, 1, ncols);
yadd = repmat(yadd, 1, ncols);
beaddist = magR1/(ncols-1);

if(imgskew > 0) %necessary because angle of sind(angc1) won't correct +/-, need to figure it out based on skew.
    beadsy = beadsy - yadd;
    beadsx = beadsx - xadd;
else
    beadsy = beadsy + yadd;
    beadsx = beadsx + xadd;
end
plot(beadsx,beadsy, '*' );
deletebeads = [];
for i = 1:length(centers(:,1))
    mindist = inf;
    for j = 1:nrows
        for k = 1:ncols
            newdist = ((centers(i,1)-beadsx(j,k)).^2 + (centers(i,2) - beadsy(j,k)).^2).^(1/2);
            if (newdist < mindist)
                mindist = newdist;
            end
        end
    end
    if (mindist > .2*beaddist)
        deletebeads = [deletebeads; i]
    end
end
centers = removerowsben(centers, deletebeads);
%find rectangle around each bead now
if(nrows == 4)
    [row1 row2 row3 row4] = return4rows(imgskew, nrows, ncols,magR1, angR1, magC1, angC1, centers, beadsx, beadsy, calimg);
end
meanrad = mean(centers(:,3));
[rows1 cols1] = size(row1);
[rows2 cols2] = size(row2);
[rows3 cols3] = size(row3);
[rows4 cols4] = size(row4);
if(rows1<5)
    row1 = findmissing(nrows, ncols, magR1, angR1, magC1, angC1, centers, beadsx, beadsy, calimg, imgskew, row1, 1);
end
if(rows2<5)
    row2 = findmissing(nrows, ncols, magR1, angR1, magC1, angC1, centers, beadsx, beadsy, calimg, imgskew,row2, 2);
 end

if(rows3<5)
    row3 = findmissing(nrows, ncols, magR1, angR1, magC1, angC1, centers, beadsx, beadsy, calimg, imgskew, row3, 3);
end
if(rows4<5)
    row4 = findmissing(nrows, ncols, magR1, angR1, magC1, angC1, centers, beadsx, beadsy, calimg, imgskew, row4,4);
end

centers = [row1;row2;row3;row4];

% if(rows2 < 2)
%     xm = row1(1,1) - 2*row1(1,3);
%     ym = row1(1,2) + 2*row1(1,3);
%      width = row1(end,1) - row1(1,1) + 4 * row1(1,3);
%      height = 4*row1(1,3);
%      imtemp = imcrop(calimg, [xm ym width height]);
%      middle = mean(mean(imtemp));
%      imtemp(find(imtemp<.7*middle)) = middle;
%      vari = std(std(double(imtemp)));
%      imtemp(find(imtemp>(middle+1.5*vari))) = 255;
%      [accum, circen, cirrad] = CircularHough_Grd(imtemp, [40  50], 5,50,0.1);
%      circen(:,1) = circen(:,1) + xm;
%      circen(:,2) = circen(:,2) + ym;
%      centerstemp = [circen cirrad];
%     [garb sorted] = sort(centerstemp(:,1));
%      centerstemp = centerstemp(sorted,:);
%      row2 = centerstemp;
%      [rows2 cols2] = size(row2);
%      if(cols2<5)
%          row2 = findmissing(row2, topleft, bottomright, calimg, meanrad,0);
%      end
% end
% if(rows3 < 2)
%     xm = row2(1,1) - 2*row2(1,3);
%     ym = row2(1,2) + 2*row2(1,3);
%      width = row1(end,1) - row1(1,1) + 4 * row1(1,3);
%      height = 4*row1(1,3);
%      imtemp = imcrop(calimg, [xm ym width height]);
%      middle = mean(mean(imtemp));
%      imtemp(find(imtemp<.7*middle)) = middle;
%      vari = std(std(double(imtemp)));
%      imtemp(find(imtemp>(middle+1.5*vari))) = 255;
%      [accum, circen, cirrad] = CircularHough_Grd(imtemp, [40  50], 5,50,0.1);
%      circen(:,1) = circen(:,1) + xm;
%      circen(:,2) = circen(:,2) + ym;
%      centerstemp = [circen cirrad];
%     [garb sorted] = sort(centerstemp(:,1));
%      centerstemp = centerstemp(sorted,:);
%      row3 = centerstemp;
%      [rows3 cols3] = size(row2);
%      if(cols3<5)
%          row3 = findmissing(row3, topleft, bottomright, calimg, meanrad,0);
%      end
% end
%centers = [row1; row2; row3; row4];

imshow(calimg);
hold on;
for k = 1:length(centers)
    DrawCircle(centers(k,1), centers(k,2), centers(k,3), 32, '-b', 2);
end


