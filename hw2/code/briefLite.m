function [ locs, desc ] = briefLite( im )
%BRIEFLITE Summary of this function goes here
%   Detailed explanation goes here

sigma0 = 1;
k = sqrt(2);
levels = [-1 0 1 2 3 4];
th_contrast = 0.03;
th_r = 12;
patchWidth = 9;
nbits = 256;

[locsDoG, gp] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r);

%plot keypoints
%figure;
%imshow(im)
%hold on
%plot(locsDoG(:,1), locsDoG(:,2), '*g')

%[cmpX, cmpY] = makeTestPattern(patchWidth, nbits);
load('testPattern.mat')

[locs, desc] = computeBrief(im, gp, locsDoG, k, levels, compareX, compareY);

end

