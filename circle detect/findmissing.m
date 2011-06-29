function [row] =  findmissing(nrows, ncols, magR1, angR1, magC1, angC1, centers, beadsx, beadsy, img,imgskew, row, rownum, debugon);
if(nargin<14)
    debugon = 0;
end
calimg = img;
meanrad = mean(centers(:,3));
[m n colors] = size(img);
if (colors>1)
    img = rgb2gray(img);
end
[ymax xmax colors] = size(calimg);
y = 1:ymax;
lengthx = abs(magR1 * cosd(angR1));
lengthy = abs(magC1 * sind(angC1));
bead1 = [];
bead2 = [];
bead3 = [];
bead4 = [];
bead5 = [];
if(imgskew < 0)
    x = beadsx(1) + (y-beadsy(1))/lengthy*cosd(angC1)*magC1 + lengthx/(ncols*2);
else
    x = beadsx(1) - (y-beadsy(1))/lengthy*cosd(angC1)*magC1 + lengthx/(ncols*2);
end
ind = [];
if(~isempty(row))
    for i = 1:length(row(:,1))
        x =  beadsx(rownum,1) + (row(i,2)-beadsy(1))/lengthy*cosd(angC1)*magC1 + lengthx/(ncols*2);
        if(row(i,1) < x)
            bead1 = row(i,:);
            ind = i;
        end
    end
    if(~isempty(row))
        if(~isempty(ind))
            row = removerowsben(row, ind);
            ind = [];
        end
        
        for i = 1:length(row(:,1))
            x =  beadsx(rownum,2) + (row(i,2)-beadsy(1))/lengthy*cosd(angC1)*magC1 + lengthx/(ncols*2);
            if(row(i,1) < x)
                bead2 = row(i,:);
                ind = i;
            end
        end
    end
    if(~isempty(row))
        if(~isempty(ind))
            row = removerowsben(row, ind);
            ind = [];
        end
        
        for i = 1:length(row(:,1))
            x =  beadsx(rownum,3) + (row(i,2)-beadsy(1))/lengthy*cosd(angC1)*magC1 + lengthx/(ncols*2);
            if(row(i,1) < x)
                bead3 = row(i,:);
                ind = i;
            end
        end
    end
    if(~isempty(row))
        if(~isempty(ind))
            row = removerowsben(row, ind);
            ind = [];
        end
        
        for i = 1:length(row(:,1))
            x =  beadsx(rownum,4) + (row(i,2)-beadsy(1))/lengthy*cosd(angC1)*magC1 + lengthx/(ncols*2);
            if(row(i,1) < x)
                bead4 = row(i,:);
                ind = i;
            end
        end
    end
    
    
    if(~isempty(row))
        if(~isempty(ind))
            row = removerowsben(row, ind);
            ind = [];
        end
        for i = 1:length(row(:,1))
            x =  beadsx(rownum,5) + (row(i,2)-beadsy(1))/lengthy*cosd(angC1)*magC1 + lengthx/(ncols*2);
            if(row(i,1) < x)
                bead5 = row(i,:);
                ind = i;
            end
        end
    end
end
b1 = ~isempty(bead1);
b2 = ~isempty(bead2);
b3 = ~isempty(bead3);
b4 = ~isempty(bead4);
b5 = ~isempty(bead5);
numbeads = b1+b2+b3+b4+b5;

if(~b1)
    bead1 = findnewcenter(img,[beadsx(rownum,1) beadsy(rownum, 1)], meanrad);
end
if(~b2)
    bead2 = findnewcenter(img,[beadsx(rownum,2) beadsy(rownum, 2)], meanrad);
end
if(~b3)
    bead3 = findnewcenter(img,[beadsx(rownum,3) beadsy(rownum, 3)], meanrad);
end
if(~b4)
    bead4 = findnewcenter(img,[beadsx(rownum,4) beadsy(rownum, 4)], meanrad);
end
if(~b5)
    bead5 = findnewcenter(img,[beadsx(rownum,5) beadsy(rownum, 5)], meanrad);
end
b1 = ~isempty(bead1);
b2 = ~isempty(bead2);
b3 = ~isempty(bead3);
b4 = ~isempty(bead4);
b5 = ~isempty(bead5);
numbeads = b1+b2+b3+b4+b5;
row = [bead1; bead2; bead3; bead4; bead5];
if(numbeads == 0)
    warnmsg = sprintf('Total Approximation for Row %1.0f', rownum);
    warning(warnmsg);
    bead1 = [beadsx(rownum,1) beadsy(rownum,1) meanrad];
    bead5 = [beadsx(rownum,5) beadsy(rownum,5) meanrad ];
    numbeads = 2;
    row = [bead1; bead2; bead3; bead4; bead5];
    b1 = 1;
    b5 = 1;
elseif(numbeads == 1)
    warnmsg = sprintf('Total Approximation for Row %1.0f', rownum);
    warning(warnmsg);
    if(b1)
        bead5 = [beadsx(rownum,5) beadsy(rownum,5) meanrad];
        b5 = 1;
    elseif(b2)
        bead5 = [beadsx(rownum,5) beadsy(rownum,5) meanrad];
        b5 = 1;
    elseif(b3)
        bead5 = [beadsx(rownum,5) beadsy(rownum,5) meanrad];
        b5=1
    elseif(b4)
        bead1 = [beadsx(rownum,1) beadsy(rownum,1) meanrad];
        b1=1;
    elseif(b5)
        bead1 = [beadsx(rownum,1) beadsy(rownum,1) meanrad];
        b1 = 1;
    else
        disp('WHAT ON EARTH?!?!?!')
    end
    numbeads = 2;
end



if(numbeads < 5)
    if(~b1)
        if(b5 & b2)
            if(debugon)
                disp('bead1: b5 and b2')
            end
            xdist = (bead5(1) - bead2(1));
            ydist = (bead5(2) - bead2(2));
            slope = ydist/xdist;
            centeraprx = [bead2(1) - xdist/3 bead2(2)-slope*xdist/3];
            bead1 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead1))
                if(debugon)
                    disp('just an approximation for bead1')
                end
                centeraprx = [centeraprx meanrad];
                bead1 = centeraprx;
            end
            row = [bead1; row];
            b1=1;
        elseif(b4 & b2)
            if(debugon)
                disp('bead1: b4 and b2');
            end
            xdist = (bead4(1) - bead2(1));
            ydist = (bead4(2) - bead2(2));
            slope = ydist/xdist;
            centeraprx = [bead2(1) - xdist/2 bead2(2)-slope*xdist/2];
            bead1 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead1))
                if(debugon)
                    disp('just an approximation for bead1')
                end
                centeraprx = [centeraprx meanrad];
                bead1 = centeraprx;
            end
            row = [bead1;row];
            b1=1;
        elseif(b5 & b3)
            if(debugon)
                disp('bead1: b5 & b3');
            end
            xdist = (bead5(1) - bead3(1));
            ydist = (bead5(2) - bead3(2));
            slope = ydist/xdist;
            centeraprx = [bead3(1) - xdist bead3(2)-slope*xdist];
            bead1 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead1))
                if(debugon)
                    disp('just an approximation for bead1')
                end
                centeraprx = [centeraprx meanrad];
                bead1 = centeraprx;
            end
            row = [bead1;row];
            b1=1;
        elseif(b3 & b2)
            if(debugon)
                disp('bead1: b3 and b2')
            end
            xdist = (bead3(1) - bead2(1));
            ydist = (bead3(2) - bead2(2));
            slope = ydist/xdist;
            centeraprx = [bead2(1) - xdist bead2(2)-slope*xdist];
            bead1 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead1))
                if(debugon)
                    disp('just an approximation for bead1')
                end
                centeraprx = [centeraprx meanrad];
                bead1 = centeraprx;
            end
            row = [bead1;row];
            b1=1;
        elseif(b4 & b3)
            if(debugon)
                disp('bead1: b4 and b3')
            end
            xdist = (bead4(1) - bead3(1));
            ydist = (bead4(2) - bead3(2));
            slope = ydist/xdist;
            centeraprx = [bead3(1) - xdist*2 bead3(2)-2*slope*xdist];
            bead1 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead1))
                if(debugon)
                    disp('just an approximation for bead1')
                end
                centeraprx = [centeraprx meanrad];
                bead1 = centeraprx;
            end
            row = [bead1;row];
            b1=1;
        elseif(b5 & b4)
            if(debugon)
                disp('bead1: b5 & b4')
            end
            xdist = (bead5(1) - bead4(1));
            ydist = (bead5(2) - bead4(2));
            slope = ydist/xdist;
            centeraprx = [bead4(1) - xdist*3 bead4(2)-3*slope*xdist];
            bead1 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead1))
                if(debugon)
                    disp('just an approximation for bead1')
                end
                centeraprx = [centeraprx meanrad];
                bead1 = centeraprx;
            end
            row = [bead1;row];
            b1=1;
            
        end
    end
    if(~b2) %b1 will exist because generated in previous step, need not account for not b1
        if(b5 & b1)
            if(debugon)
                disp('bead2: b5 and b1')
            end
            xdist = (bead5(1) - bead1(1));
            ydist = (bead5(2) - bead1(2));
            slope = ydist/xdist;
            centeraprx = [bead1(1) + xdist/4 bead1(2)+slope*xdist/4];
            bead2 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead2))
                if(debugon)
                    disp('just an approximation for bead2')
                end
                centeraprx = [centeraprx meanrad];
                bead2 = centeraprx;
            end
            row = [row(1,:); bead2; row(2:end,:)];
            b2=1;
        elseif(b4 & b1)
            if(debugon)
                disp('bead2: b4 and b1')
            end
            xdist =(bead4(1) - bead1(1));
            ydist = (bead4(2) - bead1(2));
            slope = ydist/xdist;
            centeraprx = [bead1(1) + xdist/3 bead1(2)+slope*xdist/3];
            bead2 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead2))
                if(debugon)
                    disp('just an approximation for bead2')
                end
                centeraprx = [centeraprx meanrad];
                bead2 = centeraprx;
            end
            row = [row(1,:); bead2; row(2:end,:)];
            b2=1;
        elseif(b3 & b1)
            if(debugon)
                disp('bead2: b3 and b1')
            end
            xdist =(bead3(1) - bead1(1));
            ydist =(bead3(2) - bead1(2));
            slope = ydist/xdist;
            centeraprx = [bead1(1) + xdist/2 bead1(2)+slope*xdist/2];
            bead2 = findnewcenter(img, centeraprx, meanrad);
            if(isempty(bead2))
                disp('just an approximation for bead2')
                centeraprx = [centeraprx meanrad];
                bead2 = centeraprx;
            end
            row = [row(1,:); bead2; row(2:end,:)];
            b2=1;
        end
    end
    if(~b3)
        if(b5 & b1)
            if(debugon)
                disp('bead3: b5 and b1')
            end
            xdist = (bead5(1) - bead1(1));
            ydist = (bead5(2) - bead1(2));
            slope = ydist/xdist;
            centeraprx = [bead1(1) + 2*xdist/4 bead1(2)+2*slope*xdist/4];
            
            bead3 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead3))
                if(debugon)
                    disp('just an approximation for bead3')
                end
                centeraprx = [centeraprx meanrad];
                bead3 = centeraprx;
            end
            row = [row(1:2,:); bead3; row(3:end,:)];
            b3=1;
        elseif(b4 & b1)
            if(debugon)
                disp('bead3: b4 and b1')
            end
            xdist = (bead4(1) - bead1(1));
            ydist = (bead4(2) - bead1(2));
            slope = ydist/xdist;
            centeraprx = [bead1(1) + 2*xdist/3 bead1(2)+2*slope*xdist/3];
            bead3 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead3))
                if(debugon)
                    disp('just an approximation for bead3')
                end
                centeraprx = [centeraprx meanrad];
                bead3 = centeraprx;
            end
            row = [row(1:2,:); bead3; row(3:end,:)];
            b3=1;
        elseif(b2 & b1)
            if(debugon)
                disp('bead3: b2 & b1')
            end
            xdist = (bead2(1) - bead1(1));
            ydist = (bead2(2) - bead1(2));
            slope = ydist/xdist;
            centeraprx = [bead2(1) + xdist bead2(2)+slope*xdist];
            bead3 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead3))
                if(debugon)
                    disp('just an approximation for bead3')
                end
                centeraprx = [centeraprx meanrad];
                bead3 = centeraprx;
            end
            row = [row(1:2,:); bead3; row(3:end,:)];
            b3=1;
        end
    end
    if(~b4)
        if(b5 & b1)
            if(debugon)
                disp('bead4: b5 and b1')
            end
            xdist = (bead5(1) - bead1(1));
            ydist = (bead5(2) - bead1(2));
            slope = ydist/xdist;
            centeraprx = [bead5(1) - xdist/4 bead5(2)-slope*xdist/4];
            bead4 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead4))
                if(debugon)
                    disp('just an approximation for bead4')
                end
                centeraprx = [centeraprx meanrad];
                bead4 = centeraprx;
            end
            row = [row(1:3,:); bead4; row(4:end,:)];
            b4=1;
        elseif(b3 & b1)
            if(debugon)
                disp('bead4: b3 and b1');
            end
            xdist = (bead3(1) - bead1(1));
            ydist = (bead3(2) - bead1(2));
            slope = ydist/xdist;
            centeraprx = [bead3(1) + xdist/2 bead3(2)+slope*xdist/3];
            bead4 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead4))
                if(debugon)
                    disp('just an approximation for bead4')
                end
                centeraprx = [centeraprx meanrad];
                bead4 = centeraprx;
            end
            row = [row(1:3,:); bead4; row(4:end,:)];
            b4=1;
        end
    end
    if(~b5)
        if(b4 & b1)
            if(debugon)
                disp('bead5: b4 and b1')
            end
            xdist = (bead4(1) - bead1(1));
            ydist = (bead4(2) - bead1(2));
            slope = ydist/xdist;
            centeraprx = [bead4(1) + xdist/3 bead4(2)+slope*xdist/3];
            bead5 = findnewcenter(img, centeraprx,meanrad);
            if(isempty(bead5))
                if(debugon)
                    disp('just an approximation for bead5')
                end
                centeraprx = [centeraprx meanrad];
                bead5 = centeraprx;
            end
            row = [row;bead5];
            b5=1;
        end
    end
end
row = [bead1; bead2; bead3; bead4; bead5];
function newcenter =  findnewcenter(img, center,meanrad)
xbound = center(1) - 2*meanrad;
ybound = center(2) - 2*meanrad;
rect2 = [xbound ybound 4*meanrad 4*meanrad];
img = imcrop(img,rect2);
vari = std(std(double(img)));
middle = mean(mean(img));
img(find(img > middle + 1.5 * vari)) = 255;
img(find(img < middle)) = 0;
try
[accum, circen, cirrad] = CircularHough_Grd(img, [40  50], 5,50,0.1);
catch 
    circen = [];
end
if(isempty(circen) | cirrad < 40)
    newcenter = [];
elseif(length(circen(:,1))>1)
    newcenter = [];
    warning('Found multiple centers so deleted both ');
else
    circen(1) = circen(1) + xbound;
    circen(2) = circen(2) + ybound;
    newcenter = [circen cirrad];
end

