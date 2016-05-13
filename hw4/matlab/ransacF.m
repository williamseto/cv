function [ F ] = ransacF( pts1, pts2, M )
% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.X - Extra Credit:
%     Implement RANSAC
%     Generate a matrix F from some '../data/some_corresp_noisy.mat'
%          - using sevenpoint
%          - using ransac

%     In your writeup, describe your algorith, how you determined which
%     points are inliers, and any other optimizations you made

bestInliers = [];   %inliers associated with most found
F = [];

%keep a copy of scaled points
T = [2/M 0  -1; 
     0  2/M -1;
     0   0   1];
%pts1_n = (T * [pts1, ones(size(pts1,1),1)]')';
%pts2_n = (T * [pts2, ones(size(pts1,1),1)]')';

pts1_n = [pts1, ones(size(pts1,1),1)];
pts2_n = [pts2, ones(size(pts1,1),1)];


nIter = 500;
tol = 0.005;

for i=1:nIter
    
    
    %randomly choose 7 corres. & compute F
    randidx = randperm(size(pts1, 1), 7);
    currF = sevenpoint(pts1(randidx,:), pts2(randidx,:), M);

    for j=1:size(currF, 1)
        
        testF = currF{j};
        %find inliers
        %use sampson distance error measure
        %compute vectorized
        Fx1 = testF * pts1_n';
        Fx2 = testF * pts2_n';
        denom = Fx1(1,:).^2 + Fx1(2,:).^2 + Fx2(1,:).^2 + Fx2(2,:).^2;

        %x1'Fx2
        %numer = pts1_n*testF;
        %numer = sum((numer .* pts2_n), 2).^2;
        numer = testF * pts2_n';
        numer = sum((numer' .* pts1_n), 2).^2;
        
        dists = numer ./ denom';

        inliers = find(dists <= tol);
        if length(inliers) > length(bestInliers)
            bestInliers = inliers;
            F = testF;
            bestDists = dists;
            test = currF;
        end
    end
    
    
    %{
    %try eightpoint
    randidx = randperm(size(pts1, 1), 8);
    currF = eightpoint(pts1(randidx,:), pts2(randidx,:), M);
    
    testF = currF;
    %find inliers
    %use sampson distance error measure
    %compute vectorized
    Fx1 = testF * pts1_n';
    Fx2 = testF * pts2_n';
    denom = Fx1(1,:).^2 + Fx1(2,:).^2 + Fx2(1,:).^2 + Fx2(2,:).^2;

    %x1'Fx2
    numer = pts1_n*testF;
    numer = sum((numer .* pts2_n), 2).^2;

    dists = numer ./ denom';

    inliers = find(dists <= tol);
    if length(inliers) > length(bestInliers)
        bestInliers = inliers;
        F = testF;
        bestDists = dists;
    end
    %}
end


%recompute F, using best inliers
%F = eightpoint(pts1(bestInliers,:), pts2(bestInliers,:), M);



end

