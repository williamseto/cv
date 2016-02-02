function [filterResponses] = extractFilterResponses(I, filterBank)
% CV Fall 2015 - Provided Code
% Extract the filter responses given the image and filter bank
% Pleae make sure the output format is unchanged. 
% Inputs: 
%   I:                  a 3-channel RGB image with width W and height H 
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W*H x N*3 matrix of filter responses
 
%check if greyscale and repmat if necessary
if length(size(I)) == 2
    I = repmat(I, [1 1 3]);
end

%Convert input Image to Lab
doubleI = double(I);
[L,a,b] = RGB2Lab(doubleI(:,:,1), doubleI(:,:,2), doubleI(:,:,3));
pixelCount = size(doubleI,1)*size(doubleI,2);

%filterResponses:    a W*H x N*3 matrix of filter responses
filterResponses = zeros(pixelCount, length(filterBank)*3);



%for each filter and channel, apply the filter, and vectorize

% === fill in your implementation here  ===


for i=1:length(filterBank)
    filtered_L = imfilter(L, filterBank{i}, 'replicate');
    filtered_a = imfilter(a, filterBank{i}, 'replicate');
    filtered_b = imfilter(b, filterBank{i}, 'replicate');
    
    %reshape by stacking columns
    filterResponses(:, (i-1)*3+1) = reshape(filtered_L, [], 1);
    filterResponses(:, (i-1)*3+2) = reshape(filtered_a, [], 1);
    filterResponses(:, (i-1)*3+3) = reshape(filtered_b, [], 1);
    

    
end



end
