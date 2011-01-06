function [row] =  findmissing(row,topleft,bottomright, img, meanrad,debugon) 
if (nargin<6)
    debugon = 0;
end
[m n colors] = size(img);
if (colors>1)
    img = rgb2gray(img);
end
minx = topleft(1);
xdist = (bottomright(1) - topleft(1))/4;
bead1 = row(find(row(:,1) < 1.2 * minx),:);
bead2 = row(find(row(:,1) > 1.2*minx & row(:,1) < minx + 1.2* xdist),:);
bead3 = row(find(row(:,1) > minx + 1.2*xdist & row(:,1) < minx + 1.2*2* xdist),:);
bead4 = row(find(row(:,1) > minx + 1.2*2*xdist & row(:,1) < minx + 1.2*3* xdist),:);
bead5 = row(find(row(:,1) > minx + 1.2*3*xdist & row(:,1) < minx + 1.2*4* xdist),:);
b1 = ~isempty(bead1);
b2 = ~isempty(bead2);
b3 = ~isempty(bead3);
b4 = ~isempty(bead4);
b5 = ~isempty(bead5);

if(~b1)
    if(b5 & b2)
        if(debugon)
        disp('bead1: b5 and b2')
        end
        xdist = (bead5(1) - bead2(1));
        ydist = (bead5(2) - bead2(2));
        slope = ydist/xdist;
        centeraprx = [bead2(1) - xdist/3 bead2(2)-slope*xdist/3];
        bead1 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead1))
            if(debugon)
            disp('just an approximation for bead1')
            end
            centeraprx = [centeraprx meanrad];
            bead1 = centeraprx;
        end
          row = [bead1; row];
        b1=1;
    elseif(b4 & b2)
        if(debugon)
        disp('bead1: b4 and b2');
        end
        xdist = (bead4(1) - bead2(1));
        ydist = (bead4(2) - bead2(2));
        slope = ydist/xdist;
        centeraprx = [bead2(1) - xdist/2 bead2(2)-slope*xdist/2];
        bead1 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead1))
            if(debugon)
             disp('just an approximation for bead1')
            end
            centeraprx = [centeraprx meanrad];
            bead1 = centeraprx;
        end
        row = [bead1;row];
        b1=1;
      elseif(b5 & b3)
          if(debugon)
          disp('bead1: b5 & b3');
          end
       xdist = (bead5(1) - bead3(1));
        ydist = (bead5(2) - bead3(2));
        slope = ydist/xdist;
        centeraprx = [bead3(1) - xdist bead3(2)-slope*xdist];
        bead1 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead1))
            if(debugon)
             disp('just an approximation for bead1')
            end
            centeraprx = [centeraprx meanrad];
            bead1 = centeraprx;
        end
        row = [bead1;row];
        b1=1;
    elseif(b3 & b2)
        if(debugon)
        disp('bead1: b3 and b2')
        end
        xdist = (bead3(1) - bead2(1));
        ydist = (bead3(2) - bead2(2));
        slope = ydist/xdist;
        centeraprx = [bead2(1) - xdist bead2(2)-slope*xdist];
        bead1 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead1))
            if(debugon)
             disp('just an approximation for bead1')
            end
            centeraprx = [centeraprx meanrad];
            bead1 = centeraprx;
        end
        row = [bead1;row];
        b1=1;
    elseif(b4 & b3)
        if(debugon)
        disp('bead1: b4 and b3')
        end
         xdist = (bead4(1) - bead3(1));
        ydist = (bead4(2) - bead3(2));
        slope = ydist/xdist;
        centeraprx = [bead3(1) - xdist*2 bead3(2)-2*slope*xdist];
        bead1 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead1))
            if(debugon)
             disp('just an approximation for bead1')
            end
            centeraprx = [centeraprx meanrad];
            bead1 = centeraprx;  
        end
          row = [bead1;row];
         b1=1;
    elseif(b5 & b4)
        if(debugon)
        disp('bead1: b5 & b4')
        end
          xdist = (bead5(1) - bead4(1));
        ydist = (bead5(2) - bead4(2));
        slope = ydist/xdist;
        centeraprx = [bead4(1) - xdist*3 bead4(2)-3*slope*xdist];
        bead1 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead1))
            if(debugon)
             disp('just an approximation for bead1')
            end
            centeraprx = [centeraprx meanrad];
            bead1 = centeraprx;
        end
          row = [bead1;row];
        b1=1;
        
    end
end
if(~b2) %b1 will exist because generated in previous step, need not account for not b1
    if(b5 & b1)
        if(debugon)
        disp('bead2: b5 and b1')
        end
        xdist = (bead5(1) - bead1(1));
        ydist = (bead5(2) - bead1(2));
        slope = ydist/xdist;
        centeraprx = [bead1(1) + xdist/4 bead1(2)+slope*xdist/4];
        bead2 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead2))
            if(debugon)
             disp('just an approximation for bead2')
            end
            centeraprx = [centeraprx meanrad];
            bead2 = centeraprx;
        end
        row = [row(1,:); bead2; row(2:end,:)];
        b2=1;
    elseif(b4 & b1)
        if(debugon)
        disp('bead2: b4 and b1')
        end
        xdist =(bead4(1) - bead1(1));
        ydist = (bead4(2) - bead1(2));
        slope = ydist/xdist;
        centeraprx = [bead1(1) + xdist/3 bead1(2)+slope*xdist/3];
        bead2 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead2))
            if(debugon)
             disp('just an approximation for bead2')
            end
            centeraprx = [centeraprx meanrad];
            bead2 = centeraprx;
        end
        row = [row(1,:); bead2; row(2:end,:)];
        b2=1;
    elseif(b3 & b1)
        if(debugon)
        disp('bead2: b3 and b1')
        end
        xdist =(bead3(1) - bead1(1));
        ydist =(bead3(2) - bead1(2));
        slope = ydist/xdist;
        centeraprx = [bead1(1) + xdist/2 bead1(2)+slope*xdist/2];
        bead2 = findnewcenter(img, centeraprx, meanrad);
        if(isempty(bead2))
             disp('just an approximation for bead2')
            centeraprx = [centeraprx meanrad];
            bead2 = centeraprx;
        end
        row = [row(1,:); bead2; row(2:end,:)];
        b2=1;
      end
end
if(~b3)
    if(b5 & b1)
        if(debugon)
        disp('bead3: b5 and b1')
        end
        xdist = (bead5(1) - bead1(1));
        ydist = (bead5(2) - bead1(2));
        slope = ydist/xdist;
        centeraprx = [bead1(1) + 2*xdist/4 bead1(2)+2*slope*xdist/4];
        
        bead3 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead3))
            if(debugon)
            disp('just an approximation for bead3')
            end
            centeraprx = [centeraprx meanrad];
            bead3 = centeraprx;
        end
        row = [row(1:2,:); bead3; row(3:end,:)];
        b3=1;
    elseif(b4 & b1)
        if(debugon)
        disp('bead3: b4 and b1')
        end
        xdist = (bead4(1) - bead1(1));
        ydist = (bead4(2) - bead1(2));
        slope = ydist/xdist;
        centeraprx = [bead1(1) + 2*xdist/3 bead1(2)+2*slope*xdist/3];
        bead3 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead3))
            if(debugon)
            disp('just an approximation for bead3')
            end
            centeraprx = [centeraprx meanrad];
            bead3 = centeraprx;
        end
        row = [row(1:2,:); bead3; row(3:end,:)];
        b3=1;
    elseif(b2 & b1)
        if(debugon)
        disp('bead3: b2 & b1')
        end
         xdist = (bead2(1) - bead1(1));
        ydist = (bead2(2) - bead1(2));
        slope = ydist/xdist;
        centeraprx = [bead2(1) + xdist bead2(2)+slope*xdist];
        bead3 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead3))
            if(debugon)
            disp('just an approximation for bead3')
            end
            centeraprx = [centeraprx meanrad];
            bead3 = centeraprx;
        end
        row = [row(1:2,:); bead3; row(3:end,:)];
        b3=1;
    end
end
if(~b4)
    if(b5 & b1)
        if(debugon)
        disp('bead4: b5 and b1')
        end
        xdist = (bead5(1) - bead1(1));
        ydist = (bead5(2) - bead1(2));
        slope = ydist/xdist;
        centeraprx = [bead5(1) - xdist/4 bead5(2)-slope*xdist/4];
        bead4 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead4))
            if(debugon)
            disp('just an approximation for bead4')
            end
            centeraprx = [centeraprx meanrad];
            bead4 = centeraprx;
        end
        row = [row(1:3,:); bead4; row(4:end,:)];
        b4=1;
    elseif(b3 & b1)
        if(debugon)
        disp('bead4: b3 and b1');
        end
        xdist = (bead3(1) - bead1(1));
        ydist = (bead3(2) - bead1(2));
        slope = ydist/xdist;
        centeraprx = [bead3(1) + xdist/2 bead3(2)+slope*xdist/3];
        bead4 = findnewcenter(img, centeraprx,meanrad);
        if(isempty(bead4))
            if(debugon)
            disp('just an approximation for bead4')
            end
            centeraprx = [centeraprx meanrad];
            bead4 = centeraprx;
        end
        row = [row(1:3,:); bead4; row(4:end,:)];
        b4=1;
    end
end
if(~b5)
    if(b4 & b1)
        if(debugon)
        disp('bead5: b4 and b1')
        end
        xdist = (bead4(1) - bead1(1));
        ydist = (bead4(2) - bead1(2));
        slope = ydist/xdist;
        centeraprx = [bead4(1) + xdist/3 bead4(2)+slope*xdist/3];
        bead5 = findnewcenter(img, centeraprx,meanrad);    
        if(isempty(bead5))
            if(debugon)
            disp('just an approximation for bead5')
            end
            centeraprx = [centeraprx meanrad];
            bead5 = centeraprx;
        end
        row = [row;bead5];
        b5=1;
    end
end
        
function newcenter =  findnewcenter(img, center,meanrad)
        xbound = center(1) - 2*meanrad;
        ybound = center(2) - 2*meanrad;
        rect2 = [xbound ybound 4*meanrad 4*meanrad];
        img = imcrop(img,rect2);
        vari = std(std(double(img)));
        middle = mean(mean(img));
        img(find(img > middle + 1.5 * vari)) = 255;
        img(find(img < middle)) = 0;
        [accum, circen, cirrad] = CircularHough_Grd(img, [40  50], 5,50,0.1);
        if(isempty(circen) | cirrad < 40)
            newcenter = [];
        else
            circen(1) = circen(1) + xbound;
            circen(2) = circen(2) + ybound;
        newcenter = [circen cirrad];
        end

        