function [ wordMap ] = getVisualWords( I, filterBank, dictionary )
%GETVISUAL Summary of this function goes here
%   Detailed explanation goes here

    %need to fix this
    dictionary = dictionary';
    
    %get filterresponse for entire image
    response = extractFilterResponses(I, filterBank);
    
    %compare filter response to dictionary for every pixel
    cmp = pdist2(response, dictionary);
    
    %create wordmap
    
    %get min distances and indices in each row
    [~, idx] = min(cmp, [], 2);
    
    wordMap = reshape(idx, size(I, 1), size(I, 2));


end

