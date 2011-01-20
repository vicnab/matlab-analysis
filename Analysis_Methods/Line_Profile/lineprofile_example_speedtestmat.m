clear;
img  = imread('/Users/Ben/matlab-analysis/Analysis Methods/Line Profile/fake beads for gradient test.tif');
img = img(:,:,1);
path(path,'~/matlab-analysis/circle detect/')
load line_prof_grad.mat
hold on
for k = 1 : size(centers, 1),
        DrawCircle(centers(k,1), centers(k,2), pracrad, 32, 'r-');
        
end
count = 1;
maxima = [];
tic
 for bead = 1:20;
     count = 1;
      xi(1) = round(centers(bead,1) - pracrad*2);
 xi(2) = (centers(bead,1) + pracrad*2);
 yrange = [round(centers(bead,2) - pracrad) round(centers(bead,2) + pracrad)];
    for y = min(yrange) : max(yrange)
        yi = [y y];
        c = improfile(img,xi,yi);
        axis([0 length(c) 0 255]);
        maxima(bead,count,1) = max(c(:,1,1));
        count = count + 1;        
    end
     average(bead) = mean(maxima(bead,:));
 end

 toc
