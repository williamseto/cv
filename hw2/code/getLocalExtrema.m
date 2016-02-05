function [locsDoG] = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature, th_contrast, th_r)
%GETLOCALEXTREMA Summary of this function goes here
%   Detailed explanation goes here

dog_size = size(DoGPyramid);
extrema = true(dog_size(1:2));

%must satisfy for all levels
for i=1:length(DoGLevels)
    extrema = extrema & (abs(DoGPyramid(:,:,i)) > th_contrast);
end

%convert to indices
extrema = find(extrema);

[X, Y, L] = ind2sub(dog_size(2, extrema);

locsDoG = [Y, X, DoGLevels(L)'];

end

