function [u, v] = LucasKanadeBasis(It, It1, rect, bases)

%convert to double for gradient/interpolation
It = im2double(It);
It1 = im2double(It1);

xsz = round(rect(3)-rect(1))+1;
ysz = round(rect(4)-rect(2))+1;

%sample points for interpolating rectangle in image
[x, y] = meshgrid(1:xsz, 1:ysz);

%get template from 'It'
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
sdproj = zeros(size(gradT))';

for i=1:size(bases,3)
    curr_base = bases(:,:,i);
    sdproj = sdproj + ((gradT' * curr_base(:)) * curr_base(:)');
end
sdproj = gradT' - sdproj;
H_inv = inv(sdproj*sdproj');

%initialize p based on the current rectangle
p = [rect(1); rect(2)];


dp = zeros(2,1);

delta = 999999;
threshold = 0.01;
while delta > threshold
    
    %calculate error image
    z = interp2(It1, x+p(1), y+p(2), 'cubic');
    
    %appearance basis correction
    diff = T - z;
    weights = (reshape(bases, [size(bases,1)*size(bases,2), size(bases,3)])) \ (diff(:));
    basis_T = zeros(size(T));
    for i = 1:size(bases,3)
        basis_T = basis_T + (weights(i) .* bases(:,:,i));   
    end
    error_im = T - z + basis_T;
    
    dp = sdproj * error_im(:);
    dp = H_inv * dp;
    
    p = p + dp;
    
    delta = norm(dp);
    
end



u = p(1) - rect(1);
v = p(2) - rect(2);

end

