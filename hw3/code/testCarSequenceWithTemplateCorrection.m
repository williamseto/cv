function [  ] = testCarSequenceWithTemplateCorrection(  )
%run as a script

load(fullfile('..','data','carseq.mat')); % variable name = frames. 

rect = [60, 117, 146, 152];

%rect2 is for the baseline tracker
rect2 = [60, 117, 146, 152];

%use 1st frame as template for all frames
template = frames(:,:,1);
template = template(117:152, 60:146);

rects = zeros(size(frames,3), 4);

for i=1:size(frames, 3)-1    
    
    %accumulate rects
    rects(i,:) = rect;
    
    %display frame
    imshow(frames(:,:,i));
    hold on
    rectangle('Position', [rect(1:2) 86 35], 'EdgeColor', 'y')
    rectangle('Position', [rect2(1:2) 86 35], 'EdgeColor', 'g')
    hold off
    pause(0.0001)
     
    [u, v] = LucasKanadeTemplateCorr(template, frames(:,:,i), rect);
    
    [u2, v2] = LucasKanade(frames(:,:,i), frames(:,:,i+1), rect2);
    
    
    %update rect with (u,v)
    rect = [rect(1)+u, rect(2)+v, rect(3)+u, rect(4)+v];
    rect2 = [rect2(1)+u2, rect2(2)+v2, rect2(3)+u2, rect2(4)+v2];
    
end

%set the last rect
rects(end,:) = rects(end-1,:);

% save the rects
save(fullfile('..','results','carseqrects-wcrt.mat'),'rects');


end


function [u, v] = LucasKanadeTemplateCorr(T, It1, rect)

%convert to double for gradient/interpolation
T = im2double(T);
It1 = im2double(It1);

%sample points for interpolating rectangle in image
[x, y] = meshgrid(1:87, 1:36);


%image gradient del(I) 
%for inverse compositional, take gradient of template
[delTx, delTy] = imgradientxy(T, 'CentralDifference');


%del(I)*dW/dp = [delX delY] 
%H = [delX.^2 delX*delY; delX*delY delY.^2]
%the above is for one pixel; we need to sum over the template region
H = zeros(2,2);
H(1,1) = sum(sum(delTx.^2));
H(1,2) = sum(sum(delTx .* delTy));
H(2,1) = H(1,2);
H(2,2) = sum(sum(delTy.^2));
H_inv = inv(H);


%initialize p based on the current rectangle
p = [rect(1); rect(2)];

dp = zeros(2,1);

delta = 999999;
threshold = 0.2;
while delta > threshold
    
    %calculate error image
    z = interp2(It1, x+p(1), y+p(2), 'cubic');
    error_im = T - z;
    
    %calculate each component separately
    dp(1) = sum(sum(delTx .* error_im));
    dp(2) = sum(sum(delTy .* error_im));

    dp = H_inv * dp;
    
    p = p + dp;
    
    delta = norm(dp);
    
end


u = p(1) - rect(1);
v = p(2) - rect(2);


end 
    
