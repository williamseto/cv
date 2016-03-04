function mask = SubtractDominantMotion(image1, image2)


M = LucasKanadeAffine(image1, image2);

image1 = im2double(image1);
image2 = im2double(image2);

%warp using code from warpH
tform = maketform( 'projective', M'); 
warp_im1 = imtransform(image1, tform, 'bilinear', 'XData', ...
	[1 size(image1,2)], 'YData', [1 size(image1,1)], 'Size', size(image1));

diff = image2 - warp_im1;

diff(isnan(diff)) = 0;

se = strel('disk', 6);

mask = (abs(diff) > 0.1);
mask = imclose(mask, se);




end
