
load(fullfile('..','data','sylvseq.mat'));
load(fullfile('..','data','sylvbases.mat'));

rect = [102, 62, 156, 108];
rect2 = rect;

rects = zeros(size(frames,3), 4);

for i=1:size(frames, 3)-1    
    
    %accumulate rects
    rects(i,:) = rect;
    
    %display frame
    imshow(frames(:,:,i));
    hold on
    rectangle('Position', [rect(1:2), rect(3)-rect(1), rect(4)-rect(2)], 'EdgeColor', 'y')
    rectangle('Position', [rect2(1:2) rect(3)-rect(1), rect(4)-rect(2)], 'EdgeColor', 'g')
    hold off
    pause(0.0001)
     
    [u, v] = LucasKanadeBasis(frames(:,:,i), frames(:,:,i+1), rect, bases);
    
    [u2, v2] = LucasKanade(frames(:,:,i), frames(:,:,i+1), rect2);
    
    %update rect with (u,v)
    rect = [rect(1)+u, rect(2)+v, rect(3)+u, rect(4)+v];
    rect2 = [rect2(1)+u2, rect2(2)+v2, rect2(3)+u2, rect2(4)+v2];
end

%set the last rect
rects(end,:) = rects(end-1,:);

save(fullfile('..','results','sylvseqrects.mat'), 'rects');
