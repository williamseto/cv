
%% 1.2

sigma0 = 1;
k = sqrt(2);
levels = [-1 0 1 2 3 4];
th_contrast = 0.03;
th_r = 12;
im = imread('../data/model_chickenbroth.jpg');
GaussianPyramid = createGaussianPyramid(im, sigma0, k, levels);

[dog_gp, dog_levels] = createDoGPyramid(GaussianPyramid, levels);
displayPyramid(dog_gp)

%% 1.4

[locsDoG, gp] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r);
imshow(im)
hold on
plot(locsDoG(:,1), locsDoG(:,2), '*g')

%% 5.1

im1 = imread('../data/incline_L.png');
im2 = imread('../data/incline_R.png');

[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);

[matches] = briefMatch(desc1, desc2);

p1 = locs1(matches(:,1), 1:2)';
p2 = locs2(matches(:,2), 1:2)';

H2to1 = computeH(p1, p2);

pano = imageStitching(im1, im2, H2to1);
imshow(pano)



%% 5.2

im1 = imread('../data/incline_L.png');
im2 = imread('../data/incline_R.png');

[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);

[matches] = briefMatch(desc1, desc2);

p1 = locs1(matches(:,1), 1:2)';
p2 = locs2(matches(:,2), 1:2)';

H2to1 = computeH(p1, p2);

pano = imageStitching_noClip(im1, im2, H2to1);
imshow(pano)

%% 6.2

tic
im1 = imread('../data/incline_L.png');
im2 = imread('../data/incline_R.png');

pano = generatePanorama(im1, im2);
imshow(pano)
toc

