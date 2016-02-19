function [ panoImg ] = imageStitching_noClip( img1, img2, H2to1 )
%IMAGESTITCHING_NOCLIP Summary of this function goes here
%   Detailed explanation goes here

corners = [1 1 1; size(img2,2) 1 1; 1 size(img2,1) 1; size(img2,2) size(img2,1) 1]';
warp_corners = H2to1*corners;
warp_corners = bsxfun(@rdivide, warp_corners(1:2,:), warp_corners(3,:));


out_size = [0 0];
out_size(1) = max(size(img1,1), max(warp_corners(2,:))) + max(0, -min(warp_corners(2,:)));
out_size(2) = max(size(img1,2), max(warp_corners(1,:))) + max(0, -min(warp_corners(1,:)));

out_size = ceil(out_size);

%shift frame down by max negative amount found in the y dir
M = [1 0 0; 0 1 max(0, -min(warp_corners(2,:))); 0 0 1];

warp_im1 = warpH(img1, M, out_size);
warp_im2 = warpH(img2, M*H2to1, out_size);

%simple blending
panoImg = max(warp_im1, warp_im2);


%imshow(panoImg)


end

