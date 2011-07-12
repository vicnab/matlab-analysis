function [centers meanrad] = colors_kathleen(calimg, ncols, nrows)
[accum, circen, cirrad] = CircularHough_Grd(calimg, [50  61], 3,15,1);
centers = circen;
centers = [centers cirrad];
[garb sorted] = sort(centers(:,1));
centers = centers(sorted,:);
todelete = [];
[ys xs] = size(calimg);
regdiff = min([ys/6 xs/6]).^2;
for i=1:length(centers)-1
    diffs = (centers(i,1) - centers(i+1,1)).^2 + (centers(i,2) - centers(i+1,2)).^2;
    if (diffs/regdiff < .8)
        todelete = [todelete ; i];
    end
end

if(strcmp(version('-release'), '2010b'))
    centers = removerows(centers,'ind', todelete);
else
    centers = removerows(centers,todelete);
end
imshow(calimg);
hold on;
for k = 1 : size(centers, 1),
    DrawCircle(centers(k,1), centers(k,2), cirrad(k), 32, 'r-');
end


%%to find bottom right bead and top left bead ( the two beads the
%%algorithm should ALWAYS be able to find, find the distance of the
%%centers of each bead in terms of the distance from the origin (pixel
%%0,0, top left).  The greatest distance is the bottomright bead, the
%%shortest is the top left. This allows you to determine topleft and
%%bottomright regardless of the slant of the image
[bottomy topx] = size(calimg);
distance = (centers(:,1)-0).^2 + (centers(:,2)-bottomy).^2;
bottomleft  = centers(find(distance == min(distance)),:);
topright = centers(find(distance == max(distance)),:);
imshow(calimg);hold on;
plot(bottomleft(1), bottomleft(2), 'bx');

hold off;
manualselectbottom = questdlg('Is the bottom left bead correctly selected?', ...
    'Critical Beads', ...
    'Yes', 'No', 'No');
scaledistance = 4/9*bottomy;
bottomleftimg = calimg(bottomy-scaledistance:bottomy, 1:scaledistance, :);
if(strcmp(manualselectbottom, 'No'))
    uiwait(msgbox('select center of bottom left bead', 'Bottom Left', 'modal')) 
    correct = 'No';
    while(strcmp(correct, 'No'))
        hold off;
        imshow(bottomleftimg);
        [bottomleft(1) bottomleft(2)] = ginput(1);
        imshow(calimg);
        bottomleft(2) = bottomy-scaledistance + bottomleft(2);
        hold on; plot(bottomleft(1), bottomleft(2), 'bx')
        correct = questdlg('Is the bottom left correct now?', 'Bottom Left', 'Yes', 'No', 'No');
        if(strcmp(correct, 'No'))
            uiwait(msgbox('Reselect center of bottom left bead', 'Redo', 'modal'));
        end
    end
end
hold off;
imshow(calimg); hold on;
plot(topright(1), topright(2), 'bx');
manualselecttop = questdlg('Is the top right bead correctly selected?', ...
    'Critical Beads', ...
    'Yes', 'No', 'No');
toprightimg = calimg(1:scaledistance, topx-scaledistance:topx, :);
if(strcmp(manualselecttop, 'No'))
    uiwait(msgbox('select center of top right bead', 'Bottom Left', 'modal')) 
    correct = 'No';
    while(strcmp(correct, 'No'))
        hold off;
        imshow(toprightimg);
        [topright(1) topright(2)] = ginput(1);
        imshow(calimg);
        topright(1) = topx-scaledistance + topright(1);
        hold on; plot(topright(1), topright(2), 'bx')
        correct = questdlg('Is the top right bead correct now?', 'Top Right', 'Yes', 'No', 'No');
        if(strcmp(correct, 'No'))
            uiwait(msgbox('Reselect center of top right bead', 'Redo', 'modal'));
        end
    end
end
    
a = [ 1 0]; % x unit vector
xdiag = topright(1)- bottomleft(1);
ydiag  = topright(2)- bottomleft(2);
b = [xdiag ydiag]; %vector from top left to bottom right corner
magb = norm(b); %norm function find magnitude of vector
angb = atand(ydiag/xdiag); %angle of this vector b
%ang = atand(4/5) - acosd(dot(a,b)/(norm(a)*norm(b)));
%miny = min(centers(:,2));
bmidx = topright(1) - magb *cosd(angb)*.5;
bmidy = topright(2) - magb *sind(angb)*.5;
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
c = [topright(1) - bmidx; topright(2) - bmidy];
%create rotation matrix using form R(theta) = [cos(theta) -sin(theta);
%sin(theta) cos(theta)]'
imgskew =  atand((nrows-1)/(ncols-1))+1*angb; %shows how much chip is rotated relative to image, if perfectly aligned angle o B would be atand((nrows-1)/(ncols-1)), gives clockwise rotation
thetarot = -(180 - 2 * atand((nrows-1)/(ncols-1)));
rotmat = [cosd(thetarot) -1*sind(thetarot); sind(thetarot) cosd(thetarot)];
%vector d will point from b mid to top right bead
d = rotmat * c;

magd = norm(d);
angd = atand(d(2)/d(1));
topleft(1) = bmidx - magd *cosd(angd);
topleft(2) = bmidy - magd*sind(angd);

%vector for row, vec R1
R1 = [topright(1) - topleft(1) topright(2) - topleft(2)];
magR1 = norm(R1);
angR1 = atand(R1(2)/R1(1));
B1 = topleft;
R1x = magR1/(ncols-1) * [0:ncols-1] * cosd(angR1) + B1(1);
R1y = magR1/(ncols-1) * [0:ncols-1] * sind(angR1) + B1(2);

B5 = topright;

%vector for columms
C1 = [bottomleft(1) - topleft(1) bottomleft(2) - topleft(2)];

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
    beadsx = beadsx + xadd;
else
    beadsy = beadsy + yadd;
    beadsx = beadsx + xadd;
end
beadsx = beadsx'; %this is solely so bead numbering goes across top row, then 2nd row, etc.
beadsy = beadsy';
meanrad = mean(cirrad);
centers = [];
for i = 1:ncols*nrows
    centers = [centers ; beadsx(i) beadsy(i) meanrad];
end



