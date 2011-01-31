function [row1 row2 row3 row4] = return4rows(magR1, angR1, magC1, angC1, centers, beadsx, beadsy, calimg);
load('centersflourdebug.mat');
[ymax xmax colors] = size(calimg);
x = 1:xmax;
lengthx = abs(magR1 * cosd(angR1));
lengthy = abs(magC1 * sind(angC1));
if(imgskew > 0)
    y = beadsy(1) + (x-beadsx(1))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
else
    y = beadsy(1) - (x-beadsx(1))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
end
imshow(calimg);
hold on;
plot(x,y);
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
        row1 = [row1; centers(i,:)]
       ind = [ind; i]
    end
end
 centers = removerows(centers, 'Ind', ind);
 ind = [];
for i = 1:length(centers(:,1))
    if(imgskew > 0)
        y = beadsy(6) + (centers(i,1)-beadsx(6))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
        yvec = beadsy(6) + (x-beadsx(1))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    else
        y = beadsy(6) - (centers(i,1)-beadsx(6))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
        yvec = beadsy(6) + (x-beadsx(1))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    end
    plot(x,yvec);
    if(centers(i,2) <y)
        row2 = [row2; centers(i,:)]
        ind = [ind;i];
    end
end
 centers = removerows(centers, 'Ind', ind);
 ind = [];
for i = 1:length(centers(:,1))
    if(imgskew > 0)
        y = beadsy(11) + (centers(i,1)-beadsx(11))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    else
        y = beadsy(11) - (centers(i,1)-beadsx(11))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    end
    if(centers(i,2) <y)
        row3 = [row3; centers(i,:)]
        ind = [ind;i];
    end
end
 centers = removerows(centers, 'Ind', ind);
 ind = [];
 for i = 1:length(centers(:,1))
    if(imgskew > 0)
        y = beadsy(16) + (centers(i,1)-beadsx(16))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    else
        y = beadsy(16) - (centers(i,1)-beadsx(16))/lengthx*sind(angR1)*magR1 + lengthy/(nrows*2);
    end
    if(centers(i,2) <y)
        row4 = [row4; centers(i,:)]
        ind = [ind;i];
    end
end
centers = removerows(centers, 'Ind', ind);
ind = [];
centers = [row1; row2; row3; row4];