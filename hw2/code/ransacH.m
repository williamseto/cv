function [ bestH ] = ransacH( matches, locs1, locs2, nIter, tol )
%RANSACH Summary of this function goes here
%   Detailed explanation goes here


bestInliers = [];   %inliers associated with best number
bestH = [];

%prepare correspondences
p1 = locs1(matches(:,1), 1:2)';
p2 = locs2(matches(:,2), 1:2)';

%keep a copy of homogeneous coords.
p1_h = [p1; ones(1, size(p1, 2))];
p2_h = [p2; ones(1, size(p2, 2))];

for i=1:nIter
    
    %randomly choose 5 corres. & compute H
    randidx = randperm(size(p1, 2), 5);
    testH = computeH(p1(:, randidx), p2(:, randidx));
    
    %find inliers by calculating distances
    p1_test = testH*p2_h;
    
    %normalize output by scale factor and get rid of last row
    p1_test = [p1_test(1,:) ./ p1_test(3,:); p1_test(2,:) ./ p1_test(3,:)];
    
    %compare in 2d
    dists = sqrt(sum((p1_test - p1).^2));
    
    inliers = find(dists <= tol);
    if length(inliers) > length(bestInliers)
        bestInliers = inliers;
        bestH = testH;
    end
     
    
end

%recompute H, using best inliers
bestH = computeH(p1(:, bestInliers), p2(:, bestInliers));



end

