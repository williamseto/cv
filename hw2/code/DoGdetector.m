function [locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

GaussianPyramid = createGaussianPyramid(im, sigma0, k, levels);

[dog_gp, dog_levels] = createDoGPyramid(GaussianPyramid, levels);

pc = computePrincipalCurvature(dog_gp);

locsDoG = getLocalExtrema(dog_gp, dog_levels, pc, th_contrast, th_r);


end

