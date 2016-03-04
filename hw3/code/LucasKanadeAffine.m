function M = LucasKanadeAffine(It, It1)

%convert to double for gradient/interpolation
It = im2double(It);
It1 = im2double(It1);

T = It;

%sample points for interpolating rectangle in image
[x, y] = meshgrid(1:size(T,2), 1:size(T,1));


%image gradient del(I) 
%for inverse compositional, take gradient of template
[delTx, delTy] = imgradientxy(T);

% W([x y] = [x + xp1 + yp3 + p5
%            xp2 + y + yp4 + p2]
%jacobian, dW/dp = [x 0 y 0 1 0;
%                   0 x 0 y 0 1];

%calculate steepest descent image del(T)*dW/dp
%initialize to gradients
steep = zeros(size(T,1), size(T,2), 6);
steep(:,:,1) = delTx .* x;
steep(:,:,2) = delTy .* x;
steep(:,:,3) = delTx .* y;
steep(:,:,4) = delTy .* y;
steep(:,:,5) = delTx;
steep(:,:,6) = delTy;


%calculate H
steep_res = reshape(steep, size(T(:),1), 6);
H = steep_res' * steep_res;


H_inv = inv(H);


p = zeros(6,1);
dp = zeros(6,1);

delta = 999999;
threshold = 0.01;
while delta > threshold
    
    %calculate error image, applying warp to It1
    z = interp2(It1, x+x.*p(1)+y.*p(3)+p(5), x.*p(2)+y+y.*p(4)+p(6), 'cubic');
    error_im = T - z;
    
    %account for warping that lies outside image's frame
    error_im(isnan(error_im)) = 0;
    
    %calculate each component separately
    dp(1) = sum(sum(steep(:,:,1) .* error_im));
    dp(2) = sum(sum(steep(:,:,2) .* error_im));
    dp(3) = sum(sum(steep(:,:,3) .* error_im));
    dp(4) = sum(sum(steep(:,:,4) .* error_im));
    dp(5) = sum(sum(steep(:,:,5) .* error_im));
    dp(6) = sum(sum(steep(:,:,6) .* error_im));
    
    dp = H_inv * dp;
    
    %sign problem?
    p = p + dp;
    
    delta = norm(dp);
    
end

%construct M from p's
M = [1+p(1) p(3) p(5);
     p(2) 1+p(4) p(6);
     0     0      1  ];
 


end

