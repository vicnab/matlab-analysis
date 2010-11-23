img  = imread('/Users/Ben/matlab-analysis/Analysis Methods/Line Profile/fake beads for gradient test.tif');
path(path,'~/matlab-analysis/circle detect/')
load line_prof_grad.mat
hold on
for k = 1 : size(centers, 1),
        DrawCircle(centers(k,1), centers(k,2), pracrad, 32, 'r-');
        
end
count = 1;
maxima = [];
tic
 for bead = 1;
     count = 1;
      xi(1) = round(centers(bead,1) - pracrad*2);
 xi(2) = (centers(bead,1) + pracrad*2);
 yrange = [round(centers(bead,2) - pracrad) round(centers(bead,2) + pracrad)]
    for y = min(yrange) : max(yrange)
        yi = [y y];
        c = improfile(img,xi,yi);
        axis([0 length(c) 0 255]);
        maxima(bead,count,1) = max(c(:,1,1));
        maxima(bead,count,2) = max(c(:,1,2));
        maxima(bead,count,3) = max(c(:,1,3));
        count = count + 1;        
    end
 end
 toc
rect1 = [123.5100  149.5100  117.9800   97.9800];
rect2 = [303.5100  325.5100  121.9800  103.9800];
rect3 = [481.5100  493.5100  123.9800  121.9800];
rect4 = [679.5100  681.5100  117.9800  113.9800];
im1 = imcrop(img,rect1);
im2 = imcrop(img,rect2);
im3 = imcrop(img,rect3);
im4 = imcrop(img,rect4);
figure(1); 
subplot(2,2,1);
imshow(im1);
subplot(2,2,2);
stem(maxima(2,:,1));
title('LP Red Spectrum');
subplot(2,2,3);
stem(maxima(2,:,2));
title('LP Green Spectrum');
subplot(2,2,4);
stem(maxima(2,:,3));
title('LP Blue Spectrum');

figure(2); 
subplot(2,2,1);
imshow(im2);
subplot(2,2,2);
stem(maxima(7,:,1));
title('LP Red Spectrum');
subplot(2,2,3);
stem(maxima(7,:,2));
title('LP Green Spectrum');
subplot(2,2,4);
stem(maxima(7,:,3));
title('LP Blue Spectrum');

figure(3); 
subplot(2,2,1);
imshow(im3);
subplot(2,2,2);
stem(maxima(12,:,1));
title('LP Red Spectrum');
subplot(2,2,3);
stem(maxima(12,:,2));
title('LP Green Spectrum');
subplot(2,2,4);
stem(maxima(12,:,3));
title('LP Blue Spectrum');

figure(4); 
subplot(2,2,1);
imshow(im4);
subplot(2,2,2);
stem(maxima(17,:,1));
title('LP Red Spectrum');
subplot(2,2,3);
stem(maxima(17,:,2));
title('LP Green Spectrum');
subplot(2,2,4);
stem(maxima(17,:,3));
title('LP Blue Spectrum');

    