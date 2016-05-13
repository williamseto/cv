function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q2.6 - Todo:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q2_6.mat
%
%           Explain your methods and optimization in your writeup


x1 = round(x1);
y1 = round(y1);

%get epipolar line for im2
%ep_line = [a b c] --> ax+by+c=0
ep_line = F * [x1 y1 1]';

%create gaussian weighting window
window_range = [-2:2];
sig = 1;
[wY, wX] = meshgrid(window_range, window_range);
gauss_window = exp( -(wX.^2 + wY.^2)/(2*sig^2));

%create weighted patch around point in im1
patch1 = gauss_window .* double(im1(y1+window_range, x1+window_range));


%search along epipolar line in im2
%limit search to a small range
search_y = y1-15:y1+15;

%get x location of points on epipolar line
% x = -(b/a)y - (c/a)
search_x = -(search_y*ep_line(2) + ep_line(3))/ep_line(1);
search_x = round(search_x);

%search for x2, y2 with smallest error
error = 9999999;
for i=1:length(search_x)
    
    patch2 = gauss_window .* double(im2(search_y(i)+window_range, search_x(i)+window_range));
    
    %compute distance error
    curr_error = sum((patch1(:)-patch2(:)).^2);
    
    if curr_error < error
        error = curr_error;
        x2 = search_x(i);
        y2 = search_y(i);
    end
end



end

