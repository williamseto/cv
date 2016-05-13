function ohist = hog(I)
%
% compute orientation histograms over 8x8 blocks of pixels
% orientations are binned into 9 possible bins
%
% I : grayscale image of dimension HxW
% ohist : orinetation histograms for each block. ohist is of dimension (H/8)x(W/8)x9
% TODO

% normalize the histogram so that sum over orientation bins is 1 for each block
%   NOTE: Don't divide by 0! If there are no edges in a block (ie. this counts sums to 0 for the block) then just leave all the values 0. 
% TODO


n_bins = 9;
ori_bins = linspace(-pi/2, pi/2, n_bins+1);

[mag, ori] = mygradient(I);


H = ceil(size(I,1) / 8);
W = ceil(size(I,2) / 8);

ohist = zeros(H, W, n_bins);

thresh = 0.1 * max(mag(:));
pixelEdges = (mag > thresh);
for i=1:n_bins
    
    %get all the edges(pixels) that fall into this orientation bin
    curr_edges = pixelEdges & (ori > ori_bins(i)) & (ori <= ori_bins(i+1));
    
    %the sum represents the num of edges in an 8x8 patch for a particular
    %orientation
    curr_blocks = sum(im2col(curr_edges, [8 8], 'distinct'));

    ohist(:,:,i) = reshape(curr_blocks, [H W]);
end

ohist_sum = sum(ohist,3);

%make sure we dont divide by 0
ohist_sum = max(ohist_sum, ones(size(ohist_sum)));
ohist = bsxfun(@rdivide, ohist, ohist_sum);


end