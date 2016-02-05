


sigma0 = 1;
k = sqrt(2);
levels = [-1 0 1 2 3 4];
th_contrast = 0.03;
th_r = 12;


im = imread('../data/model_chickenbroth.jpg');
gp = createGaussianPyramid(im, sigma0, k, levels);



[dog_gp, dog_levels] = createDoGPyramid(gp, levels);


pc = computePrincipalCurvature(dog_gp);

locs = getLocalExtrema(dog_gp, dog_levels, pc, th_contrast, th_r);

imshow(im)

hold on

plot(locs(:,1), locs(:,2), '*g')