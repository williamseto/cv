

%% chicken broth
im1 = imread('../data/model_chickenbroth.jpg');
im2 = imread('../data/chickenbroth_01.jpg');

[compareX, compareY] = makeTestPattern(9, 256);
save('testPattern.mat', 'compareX', 'compareY');

[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);


[matches] = briefMatch(desc1, desc2);

plotMatches(im1, im2, matches, locs1, locs2)


%% incline images

im1 = imread('../data/incline_L.png');
im2 = imread('../data/incline_R.png');

[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);

[matches] = briefMatch(desc1, desc2);

figure;
plotMatches(im1, im2, matches, locs1, locs2)

%% textbook images

im1 = imread('../data/pf_scan_scaled.jpg');
im2 = imread('../data/pf_pile.jpg');

[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);

[matches] = briefMatch(desc1, desc2);

im2 = rgb2gray(im2);

figure;
plotMatches(im1, im2, matches, locs1, locs2)

