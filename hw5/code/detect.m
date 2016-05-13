
function [x,y,score] = detect(I,template,ndet)
%
% return top ndet detections found by applying template to the given image.
%   x,y should contain the coordinates of the detections in the image
%   score should contain the scores of the detections
%


featmap = hog(I);

resp = zeros(size(featmap,1), size(featmap,2));

for i=1:size(featmap, 3)
    %correlation
    resp = resp + filter2(template(:,:,i), featmap(:,:,i));
end

%figure; imagesc(resp);

[scores, score_idx] = sort(resp(:), 'descend');

x = [];
y = [];
score = [];

idx = 0;
while (size(x,2) < ndet) && (idx < length(score_idx))
    
    idx = idx + 1;
    
    %convert linear indices back to block coordinates
    [block_y, block_x] = ind2sub(size(resp), score_idx(idx));
    
    pixel_x = block_x*8;
    pixel_y = block_y*8;
    
    %check if overlap with any previous detections
    b_overlap = 0;
    for i=1:size(x,2)
        if abs(pixel_x-x(i))<(128*sqrt(2)) && abs(pixel_y-y(i))<(128*sqrt(2))
            b_overlap = 1;
            break;
        end
    end
    
    if b_overlap == 1
        continue;
    end
    
    x = [x, pixel_x];
    y = [y, pixel_y];
    score = [score, scores(idx)];

end

end