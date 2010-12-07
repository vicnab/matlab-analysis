function centers = centers_flour(calimg)
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
 centers = removerows(centers,todelete);
 miny = min(centers(:,2));
 maxy = max(centers(:,2));
 ydist = (maxy - miny)/3;
 row1 = centers(find(centers(:,2)<1.1*miny),:);
 row2 = centers(find(centers(:,2)<1.1*(miny+ydist) & centers(:,2) > 1.1 * miny),:);
 row3 = centers(find(centers(:,2)<1.1*(miny+2*ydist) & centers(:,2) > 1.1 * (miny+1*ydist)),:);
 row4 = centers(find(centers(:,2)<1.1*(miny+3*ydist) & centers(:,2) > 1.1 * (miny+2*ydist)),:);

bottomright = row4(find(row4(:,1) == max(row4(:,1))),:);
meanrad = mean(centers(:,3));
topleft =  row1(find(row1(:,1) == min(row1(:,1))),:);
if(length(row1)<5)
     row1 = findmissing(row1,topleft, bottomright, calimg, meanrad,0);
end
if(length(row2)<5)
     row2 = findmissing(row2, topleft, bottomright, calimg, meanrad,0);
end
if(length(row3)<5)
     row3 = findmissing(row3, topleft, bottomright, calimg, meanrad,0);
end
if(length(row4)<5)
     row4 = findmissing(row4, topleft, bottomright, calimg, meanrad,0);
end

centers = [row1;row2;row3;row4];
[rows2 cols2] = size(row2);
[rows3 cols3] = size(row3);
[rows4 cols4] = size(row4);
if(rows2 < 2)
    xm = row1(1,1) - 2*row1(1,3);
    ym = row1(1,2) + 2*row1(1,3);
     width = row1(end,1) - row1(1,1) + 4 * row1(1,3);
     height = 4*row1(1,3);
     imtemp = imcrop(calimg, [xm ym width height]);
     middle = mean(mean(imtemp));
     imtemp(find(imtemp<.7*middle)) = middle;
     vari = std(std(double(imtemp)));
     imtemp(find(imtemp>(middle+1.5*vari))) = 255;
     [accum, circen, cirrad] = CircularHough_Grd(imtemp, [40  50], 5,50,0.1);
     circen(:,1) = circen(:,1) + xm;
     circen(:,2) = circen(:,2) + ym;
     centerstemp = [circen cirrad];
    [garb sorted] = sort(centerstemp(:,1));
     centerstemp = centerstemp(sorted,:);
     row2 = centerstemp;
     [rows2 cols2] = size(row2);
     if(cols2<5)
         row2 = findmissing(row2, topleft, bottomright, calimg, meanrad,0);
     end   
end
if(rows3 < 2)
    xm = row2(1,1) - 2*row2(1,3);
    ym = row2(1,2) + 2*row2(1,3);
     width = row1(end,1) - row1(1,1) + 4 * row1(1,3);
     height = 4*row1(1,3);
     imtemp = imcrop(calimg, [xm ym width height]);
     middle = mean(mean(imtemp));
     imtemp(find(imtemp<.7*middle)) = middle;
     vari = std(std(double(imtemp)));
     imtemp(find(imtemp>(middle+1.5*vari))) = 255;
     [accum, circen, cirrad] = CircularHough_Grd(imtemp, [40  50], 5,50,0.1);
     circen(:,1) = circen(:,1) + xm;
     circen(:,2) = circen(:,2) + ym;
     centerstemp = [circen cirrad];
    [garb sorted] = sort(centerstemp(:,1));
     centerstemp = centerstemp(sorted,:);
     row3 = centerstemp;
     [rows3 cols3] = size(row2);
     if(cols3<5)
         row3 = findmissing(row3, topleft, bottomright, calimg, meanrad,0);
     end   
end
centers = [row1; row2; row3; row4];
     
imshow(calimg);
hold on;
for k = 1:length(centers)
    DrawCircle(centers(k,1), centers(k,2), centers(k,3), 32, '-b', 2);
end


