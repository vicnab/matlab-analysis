%Ben Grant 11\30\2019
%Demonstrates the efficacy if mex file line_prof_averages_and_maxima which
%takes arguments ceneters, number if beads, number of lines, radius, img
%Used to generate figures for lab meeting on 12\2\2010
clear;
tic
img  = imread('/Users/Ben/matlab-analysis/Analysis_Methods/Line_Profile/fake beads for gradient test.tif'); %i made this in gimp to have "beads" showing different gradients
redimg = img(:,:,1);
greenimg = img(:,:,2);
blueimg = img(:,:,3);
grayimg = rgb2gray(img);
clear img;
if(isempty(regexp(path, '/Users/Ben/matlab-analysis/circle detect'))) %if not in path, get functions from circle_detect directory
    path(path,'~/matlab-analysis/circle detect/')
end
load line_prof_grad.mat %contains center information for similar layout with solid beads because hard to find centers of  beads with such large gradient!

count = 1;
maxima = {};

  [curmaxima averages(1,:)]  = line_prof_averages_and_maxima(round(centers),20,14,pracrad, double(redimg)); 
  maxima{1} = curmaxima;
  [maxima{2} averages(2,:)]  = line_prof_averages_and_maxima(round(centers),20,14,pracrad, double(greenimg));
  [maxima{3} averages(3,:)]  = line_prof_averages_and_maxima(round(centers),20,14,pracrad, double(blueimg));  
  [maxima{4} averages(4,:)]  = line_prof_averages_and_maxima(round(centers),20,14,pracrad, double(grayimg));
  img  = imread('/Users/Ben/matlab-analysis/Analysis_Methods/Line_Profile/fake beads for gradient test.tif');
  k = 1;
for i = 1:10 %plot line profile for all 14 lines for beads 1 to 10 in RGB and gray
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
figure(2) %plot line profile for all 14 lines for beads 11 to 20 in RGB and gray
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
    title(sprintf('Bead %2.0f', (i+10)));
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

%plot a select few beads with stem plots to demonstrate efficacy of c
%program, recalculate maxima and averages to use 20 lines to show more of
%gradient
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


