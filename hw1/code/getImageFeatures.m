function [ h ] = getImageFeatures( wordMap, dictionarySize )
%GETIMAGEFEATURES Summary of this function goes here
%   Detailed explanation goes here

    %reshape and calc histogram
    h = hist(reshape(wordMap, 1, []), 1:dictionarySize);
    
    %normalize and transpose
    h = h / norm(h,1);
    
    h = h';
end

