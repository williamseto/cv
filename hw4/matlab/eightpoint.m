function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup


N = size(pts1, 1);

%create T to scale pts before computing f
T = [2/M 0  -1; 
     0  2/M -1;
     0   0  1];

% T = [1/M 0  0; 
%      0  1/M 0;
%      0   0  1];

pts1_n = (T * [pts1, ones(N,1)]')';
pts2_n = (T * [pts2, ones(N,1)]')';


%build A
A = [pts2_n(:,1).*pts1_n(:,1), pts2_n(:,1).*pts1_n(:,2), pts2_n(:,1), ...
     pts2_n(:,2).*pts1_n(:,1), pts1_n(:,2).*pts2_n(:,2), pts2_n(:,2), ...
     pts1_n(:,1), pts1_n(:,2), ones(N, 1)];
 
%solve Af = 0
[~, ~, V] = svd(A);
F = reshape(V(:,end), [3,3])';


%constraint enforcement
[U, S, V] = svd(F);
S(:, end) = 0;
F = U*S*V';

F = refineF(F, pts1_n(:,1:2), pts2_n(:,1:2));
%unnormalize F
F = T'*F*T;



end

