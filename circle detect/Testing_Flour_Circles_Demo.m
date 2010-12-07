function Testing_Flour_Circles_Demo(row, missing)
load datafortesting
rowtest = removerows(row, missing);
newrow = findmissing(rowtest, topleft, bottomright, calimg(:,:,2), meanrad,1);
imshow(calimg);
hold on;
for k = 1 : length(newrow)
    DrawCircle(newrow(k,1), newrow(k,2), newrow(k,3), 32, '-b', 2);
end
%pause
[m n] = size(row);
for k = 1 : m
    DrawCircle(row(k,1), row(k,2), row(k,3), 16, 'xr', 1);
end