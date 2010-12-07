clear;
tic
img  = imread('/Users/Ben/matlab-analysis/Analysis_Methods/Line_Profile/fake beads for gradient test.tif');
redimg = img(:,:,1);
greenimg = img(:,:,2);
blueimg = img(:,:,3);
grayimg = rgb2gray(img);
clear img;
if(isempty(regexp(path, '/Users/Ben/matlab-analysis/circle detect')))
    path(path,'~/matlab-analysis/circle detect/')
end
load line_prof_grad.mat

count = 1;
maxima = {};

 for bead = 1:20;
     count = 1;
     xmin = round(centers(bead,1) - pracrad*2);
     xmax = round(centers(bead,1) + pracrad*2);
     ymin = round(centers(bead,2) - pracrad);
     ymax = round(centers(bead,2) + pracrad);
     %sprintf('xmin: %d, xmax: %d, ymin:%d, ymax: %d', xmin, xmax, ymin, ymax)
    
     %maxima{bead,2} = line_prof(xi(1)-1, xi(2)-1, min(yrange)-1, max(yrange)-1, double(greenimg)); 
     %maxima{bead,3} = line_prof(xi(1)-1, xi(2)-1, min(yrange)-1, max(yrange)-1, double(blueimg)); 
     %maxima{bead,4} = line_prof(xi(1)-1, xi(2)-1, min(yrange)-1, max(yrange)-1, double(grayimg)); 
 end
  [curmaxima averages(1,:)]  = line_prof_averages_and_maxima(round(centers),20,14,pracrad, double(redimg)); 
  maxima{1} = curmaxima;
  [maxima{2} averages(2,:)]  = line_prof_averages_and_maxima(round(centers),20,14,pracrad, double(greenimg));
  [maxima{3} averages(3,:)]  = line_prof_averages_and_maxima(round(centers),20,14,pracrad, double(blueimg));  
  [maxima{4} averages(4,:)]  = line_prof_averages_and_maxima(round(centers),20,14,pracrad, double(grayimg));
  img  = imread('/Users/Ben/matlab-analysis/Analysis_Methods/Line_Profile/fake beads for gradient test.tif');
  k = 1;
for i = 1:10
    if(i>5)
        j = i+5;
    else
        j=i;
    end
    subplot(4,5,j);
    xmin = centers(i,1) - pracrad*2;
    ymin = centers(i,2) - pracrad*2;
    width = 4*pracrad;
    height = width;
    imshow(imcrop(img,[xmin ymin width height]));
    title(sprintf('Bead %1.0f', i));
    k = j+5;
    subplot(4,5,k)
    plot(maxima{1}(:,i), '*-r')
    hold on; 
    plot(maxima{2}(:,i), '^-g')
    plot(maxima{3}(:,i), 'x-b')
    plot(maxima{4}(:,i), 'o-k')
    axis([0 length(maxima{1}(:,i)) 0 255]);
    k = k+1;
    title('Max Intensity from top to bottom')
    
end
figure(2)
for i = 1:10
    if(i>5)
        j = i+5;
    else
        j=i;
    end
    subplot(4,5,j);
    xmin = centers(i+10,1) - pracrad*2;
    ymin = centers(i+10,2) - pracrad*2;
    width = 4*pracrad;
    height = width;
    imshow(imcrop(img,[xmin ymin width height]));
    title(sprintf('Bead %1.0f', i));
    k = j+5;
    subplot(4,5,k)
    plot(maxima{1}(:,i+10), '*-r')
    hold on; 
    plot(maxima{2}(:,i+10), '^-g')
    plot(maxima{3}(:,i+10), 'x-b')
    plot(maxima{4}(:,i+10), 'o-k')
    axis([0 length(maxima{1}(:,i+10)) 0 255]);
    k = k+1;
    title('Max Intensity from top to bottom')
    
end
figure(3);
 [curmaxima averages(1,:)]  = line_prof_averages_and_maxima(round(centers),20,20,pracrad, double(redimg)); 
  maxima{1} = curmaxima;
  [maxima{2} averages(2,:)]  = line_prof_averages_and_maxima(round(centers),20,20,pracrad, double(greenimg));
  [maxima{3} averages(3,:)]  = line_prof_averages_and_maxima(round(centers),20,20,pracrad, double(blueimg));  
  [maxima{4} averages(4,:)]  = line_prof_averages_and_maxima(round(centers),20,20,pracrad, double(grayimg));
subplot(2,2,1);
i = 2;
xmin = centers(i,1) - pracrad*2;
    ymin = centers(i,2) - pracrad*2;
    width = 4*pracrad;
    height = width;
    imshow(imcrop(img,[xmin ymin width height]));
    hold on;
    H = line([xmin-xmin xmin+4*pracrad-xmin], [centers(i,2) - 10-ymin centers(i,2)-10-ymin]);
    set(H, 'color','y')
    H= line([xmin-xmin xmin+4*pracrad-xmin], [centers(i,2) + 10-ymin centers(i,2)+10-ymin]);
    set(H, 'color','y')
    title(sprintf('Bead %1.0f', i));
    
    subplot(2,2,2)
    stem(maxima{1}(:,i), '*-r')
    title('Red intensity from top line to bottom line');
    xlabel('Line number');
    ylabel('Intensity');
    axis([0 length(maxima{1}(:,i))+1 0 255]);
    subplot(2,2,3)
    stem(maxima{2}(:,i), '^-g')
    title('Green intensity from top line to bottom line');
    xlabel('Line number');
    ylabel('Intensity');
    axis([0 length(maxima{2}(:,i))+1 0 255]);
    subplot(2,2,4)
    stem(maxima{3}(:,i), 'x-b')
    title('Blue intensity from top line to bottom line');
    xlabel('Line number');
    ylabel('Intensity');
    axis([0 length(maxima{3}(:,i))+1 0 255]);
  figure(4);

subplot(2,2,1);
i = 7;
xmin = centers(i,1) - pracrad*2;
    ymin = centers(i,2) - pracrad*2;
    width = 4*pracrad;
    height = width;
    imshow(imcrop(img,[xmin ymin width height]));
    hold on;
    H = line([xmin-xmin xmin+4*pracrad-xmin], [centers(i,2) - 10-ymin centers(i,2)-10-ymin]);
    set(H, 'color','y')
    H= line([xmin-xmin xmin+4*pracrad-xmin], [centers(i,2) + 10-ymin centers(i,2)+10-ymin]);
    set(H, 'color','y')
    title(sprintf('Bead %1.0f', i));
    
    subplot(2,2,2)
    stem(maxima{1}(:,i), '*-r')
    title('Red intensity from top line to bottom line');
    xlabel('Line number');
    ylabel('Intensity');
    axis([0 length(maxima{1}(:,i))+1 0 255]);
    subplot(2,2,3)
    stem(maxima{2}(:,i), '^-g')
    title('Green intensity from top line to bottom line');
    xlabel('Line number');
    ylabel('Intensity');
    axis([0 length(maxima{2}(:,i))+1 0 255]);
    subplot(2,2,4)
    stem(maxima{3}(:,i), 'x-b')
    title('Blue intensity from top line to bottom line');
    xlabel('Line number');
    ylabel('Intensity');
    axis([0 length(maxima{3}(:,i))+1 0 255]);

      figure(5);

subplot(2,2,1);
i = 12;
xmin = centers(i,1) - pracrad*2;
    ymin = centers(i,2) - pracrad*2;
    width = 4*pracrad;
    height = width;
    imshow(imcrop(img,[xmin ymin width height]));
    hold on;
    H = line([xmin-xmin xmin+4*pracrad-xmin], [centers(i,2) - 10-ymin centers(i,2)-10-ymin]);
    set(H, 'color','y')
    H= line([xmin-xmin xmin+4*pracrad-xmin], [centers(i,2) + 10-ymin centers(i,2)+10-ymin]);
    set(H, 'color','y')
    title(sprintf('Bead %1.0f', i));
    
    subplot(2,2,2)
    stem(maxima{1}(:,i), '*-r')
    title('Red intensity from top line to bottom line');
    xlabel('Line number');
    ylabel('Intensity');
    axis([0 length(maxima{1}(:,i))+1 0 255]);
    subplot(2,2,3)
    stem(maxima{2}(:,i), '^-g')
    title('Green intensity from top line to bottom line');
    xlabel('Line number');
    ylabel('Intensity');
    axis([0 length(maxima{2}(:,i))+1 0 255]);
    subplot(2,2,4)
    stem(maxima{3}(:,i), 'x-b')
    title('Blue intensity from top line to bottom line');
    xlabel('Line number');
    ylabel('Intensity');
    axis([0 length(maxima{3}(:,i))+1 0 255]);

 toc
 
       figure(6);

subplot(2,2,1);
i = 17;
xmin = centers(i,1) - pracrad*2;
    ymin = centers(i,2) - pracrad*2;
    width = 4*pracrad;
    height = width;
    imshow(imcrop(img,[xmin ymin width height]));
    hold on;
    H = line([xmin-xmin xmin+4*pracrad-xmin], [centers(i,2) - 10-ymin centers(i,2)-10-ymin]);
    set(H, 'color','y')
    H= line([xmin-xmin xmin+4*pracrad-xmin], [centers(i,2) + 10-ymin centers(i,2)+10-ymin]);
    set(H, 'color','y')
    title(sprintf('Bead %1.0f', i));
    
    subplot(2,2,2)
    stem(maxima{1}(:,i), '*-r')
    title('Red intensity from top line to bottom line');
    xlabel('Line number');
    ylabel('Intensity');
    axis([0 length(maxima{1}(:,i))+1 0 255]);
    subplot(2,2,3)
    stem(maxima{2}(:,i), '^-g')
    title('Green intensity from top line to bottom line');
    xlabel('Line number');
    ylabel('Intensity');
    axis([0 length(maxima{2}(:,i))+1 0 255]);
    subplot(2,2,4)
    stem(maxima{3}(:,i), 'x-b')
    title('Blue intensity from top line to bottom line');
    xlabel('Line number');
    ylabel('Intensity');
    axis([0 length(maxima{3}(:,i))+1 0 255]);

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
