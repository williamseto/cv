function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%

Dx = conv2(I, [-1 0 1], 'same');
Dy = conv2(I, [-1 0 1]', 'same');

mag = sqrt(Dx.*Dx + Dy.*Dy);
ori = atan2(Dy, Dx);

end

