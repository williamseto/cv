function template = tl_lda(template_images_pos, template_images_neg, lambda)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
%     template_images_neg - a cell array, each one contains [16 x 16 x 9] matrix
%     lambda - parameter for lda
% output:
%     template - [16 x 16 x 9] matrix 


pos_template = zeros(16,16,9);
neg_template = zeros(16,16,9);

%take mean of positive templates
for i=1:size(template_images_pos,1)
    
    pos_template = pos_template + hog(template_images_pos{i});
end
pos_template = pos_template/size(template_images_pos,1);


hog_neg_templates = cell(size(template_images_neg));
%take mean of negative templates
for i=1:size(template_images_neg,1)
    %save negative templates for computing covariance
    hog_neg_templates{i} = hog(template_images_neg{i});
    neg_template = neg_template + hog_neg_templates{i};
end
neg_template = neg_template/size(template_images_neg,1);

%compute covariance of negative template
cov_neg = zeros(2304,2304);
for i=1:size(template_images_neg,1)
    
    curr_template = hog_neg_templates{i};
    cov_neg = cov_neg + (curr_template(:)-neg_template(:)) * (curr_template(:)-neg_template(:))';
end

cov_neg = cov_neg/size(template_images_neg,1) + lambda*eye(size(cov_neg));

template = inv(cov_neg) * (pos_template(:)-neg_template(:));
template = reshape(template, [16 16 9]);


end