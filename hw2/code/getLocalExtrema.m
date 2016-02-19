function [locsDoG] = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature, th_contrast, th_r)
%GETLOCALEXTREMA Summary of this function goes here
%   Detailed explanation goes here

maxima = find(imregionalmax(DoGPyramid) & (abs(DoGPyramid) > th_contrast) & (PrincipalCurvature < th_r));

minima = find(imregionalmin(DoGPyramid) & (abs(DoGPyramid) > th_contrast) & (PrincipalCurvature < th_r));

%without edge suppression
%maxima = find(imregionalmax(DoGPyramid) & (abs(DoGPyramid) > th_contrast));
%minima = find(imregionalmin(DoGPyramid) & (abs(DoGPyramid) > th_contrast));

%convert to subscripts

[maxX, maxY, maxL] = ind2sub(size(DoGPyramid), maxima);
[minX, minY, minL] = ind2sub(size(DoGPyramid), minima);

%output coordinates in image coordinate system
locsDoG = [maxY, maxX, DoGLevels(maxL)';
           minY, minX, DoGLevels(minL)'];

end

