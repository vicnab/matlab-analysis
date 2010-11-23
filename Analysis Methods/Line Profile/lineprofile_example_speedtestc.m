clear;
tic
img  = imread('/Users/Ben/matlab-analysis/Analysis Methods/Line Profile/fake beads for gradient test.tif');
redimg = img(:,:,1);
greenimg = img(:,:,2);
blueimg = img(:,:,3);
grayimg = rgb2gray(img);
clear img;
path(path,'~/matlab-analysis/circle detect/')
load line_prof_grad.mat

count = 1;
maxima = [];

 for bead = 1:20;
     count = 1;
     xi(1) = round(centers(bead,1) - pracrad*2);
     xi(2) = (centers(bead,1) + pracrad*2);
     yrange = [round(centers(bead,2) - pracrad) round(centers(bead,2) + pracrad)];
     average(bead,1) = line_prof(xi(1)-1, xi(2)-1, min(yrange)-1, max(yrange)-1, double(redimg)); 
     average(bead,2) = line_prof(xi(1)-1, xi(2)-1, min(yrange)-1, max(yrange)-1, double(greenimg)); 
     average(bead,3) = line_prof(xi(1)-1, xi(2)-1, min(yrange)-1, max(yrange)-1, double(blueimg)); 
     average(bead,4) = line_prof(xi(1)-1, xi(2)-1, min(yrange)-1, max(yrange)-1, double(grayimg)); 
 end

 toc
% img  = imread('/Users/Ben/matlab-analysis/Analysis Methods/Line Profile/fake beads for gradient test.tif');
% close all;
% for i = 1:3
%     figure(i);
%     subplot(2,1,1), imshow(img(:,:,i)), subplot(2,1,2); stem(average(:,i))
%     
% end
% figure(4)
% subplot(2,1,1), imshow(grayimg), subplot(2,1,2); stem(average(:,4))

