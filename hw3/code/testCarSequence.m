
load(fullfile('..','data','carseq.mat')); % variable name = frames. 


rect = [60, 117, 146, 152];
rects = zeros(size(frames,3), 4);

for i=1:size(frames, 3)-1    
    
    %accumulate rects
    rects(i,:) = rect;
    
    %display frame
    imshow(frames(:,:,i));
    hold on
    rectangle('Position', [rect(1:2) 86 35], 'EdgeColor', 'y')
    hold off
    pause(0.0001)
     
    [u, v] = LucasKanade(frames(:,:,i), frames(:,:,i+1), rect);
       
    %update rect with (u,v)
    rect = [rect(1)+u, rect(2)+v, rect(3)+u, rect(4)+v];
end

%set the last rect
rects(end,:) = rects(end-1,:);

% save the rects
save(fullfile('..','results','carseqrects.mat'),'rects');
