subplot(2,1,1);
imshow(img);
count = 1;
maxima = [];
 xi(1) = centers(1,1) - pracrad*2;
 xi(2) = centers(1,1) + pracrad*2;
for y = centers(1,2) - pracrad:centers(1,2) + pracrad
    yi = [y y];
    subplot(2,1,1)
    line(xi,yi)
    subplot(2,1,2)
    improfile(img,xi,yi);
    c = improfile(img,xi,yi);
    maxima(count,1) = max(c(:,1,1));
    maxima(count,2) = max(c(:,1,2));
    maxima(count,3) = max(c(:,1,3));
    count = count + 1;
    pause(.1)
end