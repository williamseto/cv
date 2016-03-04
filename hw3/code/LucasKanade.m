
function [u, v] = LucasKanade(It, It1, rect)

%convert to double for gradient/interpolation
It = im2double(It);
It1 = im2double(It1);

%round the size of of our template since rect may not be int
xsz = round(rect(3)-rect(1))+1;
ysz = round(rect(4)-rect(2))+1;

%sample points for interpolating rectangle in image
[x, y] = meshgrid(1:xsz, 1:ysz);


%get template from 'It'
%T = It(rect(2):rect(4), rect(1):rect(3));
T = interp2(It, x+rect(1), y+rect(2), 'cubic');

%image gradient del(I) 
%for inverse compositional, take gradient of template
[delTx, delTy] = imgradientxy(T, 'CentralDifference');

% W = [x + p1
%      y + p2]
%jacobian, dW/dp = [dWx/dp1 dWx/dp2; dWy/dp1 dWy/dp2];
J = [1 0; 0 1];

%del(I)*dW/dp = [delX delY] 
%H = [delX.^2 delX*delY; delX*delY delY.^2]
%the above is for one pixel; we need to sum over the template region

gradT = [delTx(:), delTy(:)];
% H = zeros(2,2);
% H(1,1) = sum(sum(delTx.^2));
% H(1,2) = sum(sum(delTx .* delTy));
% H(2,1) = H(1,2);
% H(2,2) = sum(sum(delTy.^2));
H_inv = inv(gradT'*gradT);




%initialize p based on the current rectangle
p = [rect(1); rect(2)];


dp = zeros(2,1);

delta = 999999;
threshold = 0.1;
while delta > threshold
    
    %calculate error image
    z = interp2(It1, x+p(1), y+p(2), 'cubic');
    error_im = T - z;
    
    %calculate each component separately
    %dp(1) = sum(sum(delTx .* error_im));
    %dp(2) = sum(sum(delTy .* error_im));
    dp = gradT' * error_im(:);
    
    dp = H_inv * dp;
    
    p = p + dp;
    
    delta = norm(dp);
    
end


u = p(1) - rect(1);
v = p(2) - rect(2);


end 
    
