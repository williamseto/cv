function [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels)
%CREATEDOGPYRAMID Summary of this function goes here
%   Detailed explanation goes here

gp_size = size(GaussianPyramid);

DoGPyramid = zeros([gp_size(1:2), length(levels)-1]);

for i = 2:length(levels)
    DoGPyramid(:,:,i-1) = GaussianPyramid(:,:,i) - GaussianPyramid(:,:,i-1);
end

DoGLevels = levels(2:end);

end

