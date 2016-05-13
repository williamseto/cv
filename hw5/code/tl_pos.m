function template = tl_pos(template_images_pos)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
% output:
%     template - [16 x 16 x 9] matrix

template = zeros(16,16,9);

for i=1:size(template_images_pos,1)
    
    template = template + hog(template_images_pos{i});
end

template = template/size(template_images_pos,1);

end