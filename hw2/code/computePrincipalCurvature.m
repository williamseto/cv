function [ PrincipalCurvature ] = computePrincipalCurvature( DoGPyramid )
%COMPUTEPRINCIPALCURVATURE Summary of this function goes here
%   Detailed explanation goes here

PrincipalCurvature = zeros(size(DoGPyramid));

for i=1:size(DoGPyramid, 3)
    
    [Dx, Dy] = gradient(DoGPyramid(:, :, i));
    
    [Dxx, Dxy] = gradient(Dx);
    [Dyx, Dyy] = gradient(Dy);
    
    trH = Dxx + Dyy;
    detH = Dxx.*Dyy - Dxy.*Dyx;
    
    R = (trH .^ 2) ./ (detH);
    
    PrincipalCurvature(:,:,i) = R;
    
end

end

