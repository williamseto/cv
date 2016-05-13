
clear;
findM2;

im2 = imread('../data/im2.png');


load('../data/templeCoords.mat');

x2 = zeros(size(x1));
y2 = zeros(size(x1));

for i=1:size(x1,1)
    
    [x2(i), y2(i)] = epipolarCorrespondence(im1, im2, F, x1(i), y1(i));
end


[P, error] = triangulate(K1*M1, [x1, y1], K2*M2, [x2, y2]);

scatter3(P(:,1), P(:,2), P(:,3))