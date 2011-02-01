function [row1 row2 row3 row4] = return4rows(imgskew,nrows, ncols,magR1, angR1, magC1, angC1, centers, beadsx, beadsy, calimg);
[ymax xmax colors] = size(calimg);
x = 1:xmax;
lengthx = abs(magR1 * cosd(angR1));
lengthy = abs(magC1 * sind(angC1));
imshow(calimg);
hold on;
row1 = [];
row2 = [];
row3 = [];
row4 = [];
ind = [];
for i = 1:length(centers(:,1))
    if(imgskew > 0)
        y = beadsy(1) + (centers(i,1)-beadsx(1))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    else
        y = beadsy(1) - (centers(i,1)-beadsx(1))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    end
    if(centers(i,2) <y)
        row1 = [row1; centers(i,:)];
        ind = [ind; i];
    end
end
centers = removerowsben(centers, ind);
ind = [];
for i = 1:length(centers(:,1))
    if(imgskew > 0)
        y = beadsy(6) + (centers(i,1)-beadsx(6))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    else
        y = beadsy(6) - (centers(i,1)-beadsx(6))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    end
    if(centers(i,2) <y)
        row2 = [row2; centers(i,:)];
        ind = [ind;i];
    end
end
centers = removerowsben(centers, ind);
ind = [];
for i = 1:length(centers(:,1))
    if(imgskew > 0)
        y = beadsy(11) + (centers(i,1)-beadsx(11))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    else
        y = beadsy(11) - (centers(i,1)-beadsx(11))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    end
    if(centers(i,2) <y)
        row3 = [row3; centers(i,:)];
        ind = [ind;i];
    end
end
centers = removerowsben(centers, ind);
ind = [];
for i = 1:length(centers(:,1))
    if(imgskew > 0)
        y = beadsy(16) + (centers(i,1)-beadsx(16))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    else
        y = beadsy(16) - (centers(i,1)-beadsx(16))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    end
    if(centers(i,2) <y)
        row4 = [row4; centers(i,:)];
        ind = [ind;i];
    end
end
centers = removerowsben(centers, ind);
ind = [];
centers = [row1; row2; row3; row4];