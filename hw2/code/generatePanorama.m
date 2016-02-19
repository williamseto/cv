function [ im3 ] = generatePanorama( im1, im2 )
%GENERATEPANORAMA Summary of this function goes here
%   Detailed explanation goes here

[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);

[matches] = briefMatch(desc1, desc2);

bestH = ransacH(matches, locs1, locs2, 300, 0.25);

im3 = imageStitching_noClip(im1, im2, bestH);

end

