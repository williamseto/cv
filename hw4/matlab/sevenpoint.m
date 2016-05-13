function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup


N = size(pts1, 1);

%create T to scale pts before computing f
%scale and translate coordinate system
T = [1/M 0  0; 
     0  1/M 0;
     0   0   1];

pts1_n = (T * [pts1, ones(N,1)]')';
pts2_n = (T * [pts2, ones(N,1)]')';


%build A
A = [pts2_n(:,1).*pts1_n(:,1), pts2_n(:,1).*pts1_n(:,2), pts2_n(:,1), ...
     pts2_n(:,2).*pts1_n(:,1), pts1_n(:,2).*pts2_n(:,2), pts2_n(:,2), ...
     pts1_n(:,1), pts1_n(:,2), ones(N, 1)];

%{
%solve Af = 0
[~, ~, V] = svd(A);

%solve for possible Fs
F1 = reshape(V(:,end), [3,3])';
F2 = reshape(V(:,end-1), [3,3])';
%}

nv = null(A);
F1 = reshape(nv(:,1), [3,3])';
F2 = reshape(nv(:,2), [3,3])';  

syms a
det_eq = det(a*F1 + (1-a)*F2);
sols = roots(sym2poly(det_eq));

%find real solutions
F = {};

for i=1:length(sols)
    
    if isreal(sols(i))
        %unnormalize F
        
        currF = T'*(sols(i)*F1 + (1-sols(i))*F2)*T;
        currF = refineF(currF, pts1, pts2);
        F = [F; {currF}];
    end
      
end

end

