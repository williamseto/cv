function [ P, error ] = triangulate( M1, p1, M2, p2 )
% triangulate:
%       M1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       M2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

% Q2.4 - Todo:
%       Implement a triangulation algorithm to compute the 3d locations
%       See Szeliski Chapter 7 for ideas
%

%[M1 -p1 0;     [X;
% M2  0  -p2]  = lambda1;
%                lambda2]


N = size(p1, 1);

P = zeros(N, 3);
error = 0;

A = zeros(6,6);
A(1:3, 1:4) = M1;
A(4:6, 1:4) = M2;

for i=1:N
    
   A(1:3, 5) = -[p1(i,:) 1]';
   A(4:6, 6) = -[p2(i,:) 1]';
   
   [~, ~, V] = svd(A);
   
   %least squares triangulated 3D point
   X = V(:,end)';

   %unscale
   P(i,:) = X(1:3) ./ X(4);
   
   %accumulate reprojection error
   proj1 = M1 * [P(i,:), 1]';
   proj2 = M2 * [P(i,:), 1]';
   
   %unscale
   proj1 = proj1(1:2) ./ proj1(3);
   proj2 = proj2(1:2) ./ proj2(3);
   
   error = error + (sum((proj1' - p1(i,:)).^2) + sum((proj2' - p2(i,:)).^2));
     
end



end

