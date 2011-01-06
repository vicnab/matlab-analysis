calimg = imread('15ng_step5_PBSfinalwash_g+15_off0_expo380ms.tif');
 [accum, circen, cirrad] = CircularHough_Grd(calimg(:,:,2), [35  50], 5,15,1);
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
     row1 = findmissing(row1,topleft, bottomright, calimg(:,:,2), meanrad,0);
end
if(length(row2)<5)
     row2 = findmissing(row2, topleft, bottomright, calimg(:,:,2), meanrad,0);
end
if(length(row3)<5)
     row3 = findmissing(row3, topleft, bottomright, calimg(:,:,2), meanrad,0);
end
if(length(row4)<5)
     row4 = findmissing(row4, topleft, bottomright, calimg(:,:,2), meanrad,0);
end
centers = [row1;row2;row3;row4];
imshow(calimg);
hold on;
for k = 1:length(centers)
    DrawCircle(centers(k,1), centers(k,2), centers(k,3), 32, '-b', 2);
end


