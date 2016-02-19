function [ panoImg ] = imageStitching( img1, img2, H2to1 )
%IMAGEST Summary of this function goes here
%   Detailed explanation goes here

out_size = size(img1) + size(img2);
warp_im1 = warpH(img1, eye(3), out_size);
warp_im2 = warpH(img2, H2to1, out_size);
panoImg = max(warp_im1, warp_im2);

end

