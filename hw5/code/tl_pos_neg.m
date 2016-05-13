function template = tl_pos_neg(template_images_pos, template_images_neg)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
%     template_images_neg - a cell array, each one contains [16 x 16 x 9] matrix
% output:
%     template - [16 x 16 x 9] matrix 


pos_template = zeros(16,16,9);
neg_template = zeros(16,16,9);

%take mean of positive templates
for i=1:size(template_images_pos,1)
    
    pos_template = pos_template + hog(template_images_pos{i});
end

%take mean of negative templates
for i=1:size(template_images_neg,1)
    
    neg_template = neg_template + hog(template_images_neg{i});
end

template = pos_template/size(template_images_pos,1) - neg_template/size(template_images_neg,1);

end