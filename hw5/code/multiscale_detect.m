function det_res = multiscale_detect(image, template, ndet)
% input:
%     image - test image.
%     template - [16 x 16x 9] matrix.
%     ndet - the number of return values.
% output:
%      det_res - [ndet x 3] matrix
%                column one is the x coordinate
%                column two is the y coordinate
%                column three is the scale, i.e. 1, 0.7 or 0.49 ..

det_res = zeros(ndet, 3);

scale_factor = 0.7;

curr_scale = 1;
%image = imresize(image, curr_scale);
all_x = [];
all_y = [];
all_scales = [];
all_scores = [];
while any(size(image) > [128,128])
    
    [x,y,score] = detect(image,template,ndet);

    all_x = [all_x, x];
    all_y = [all_y, y];
    all_scores = [all_scores, score];
    all_scales = [all_scales, ones(1,size(x,2))*curr_scale];
    
    curr_scale = curr_scale * scale_factor;
    image = imresize(image, scale_factor);
    
end

[~, sort_idx] = sort(all_scores, 'descend');

det_res(:,1) = all_x(sort_idx(1:ndet));
det_res(:,2) = all_y(sort_idx(1:ndet));
det_res(:,3) = all_scales(sort_idx(1:ndet));

end
