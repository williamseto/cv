% Q2.5 - Todo:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       4. Save the correct M2, p1, p2, R and P to q2_5.mat

%1
load('../data/some_corresp.mat');

%2
im1 = imread('../data/im1.png');
M = max(size(im1));
F = eightpoint(pts1, pts2, M);

load('../data/intrinsics.mat')
E = essentialMatrix(F, K1, K2);

M2s = camera2(E);
M1 = [eye(3), zeros(3,1)];
for i=1:4
   
    curr_M2 = M2s(:,:,i);
    [P, err] = triangulate(K1*M1, pts1, K2*curr_M2, pts2);
    
    %check if points if positive z value
    %also check that the camera is facing the positive z direction
    %camera direction is R'*[0 0 1]'
    %if all(P(:,3) > 0) && (curr_M2(3,3) > 0)
    if all(P(:,3) > 0)
        M2 = M2s(:,:,i);
        break
    end
    
end
