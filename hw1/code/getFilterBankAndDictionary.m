function [ filterBank, dictionary ] = getFilterBankAndDictionary( image_names )
%GETFILTERBANKANDDICTIONARY Summary of this function goes here
%   Detailed explanation goes here

    alpha = 150;
    K = 100;
    
    filterBank = createFilterBank();
    
    filter_responses = zeros(alpha*length(image_names), length(filterBank)*3);
    
    for i=1:length(image_names)
        
        % to see the progress
        i
        
        im = imread(image_names{i});
        pixelCount = size(im,1)*size(im,2);

        
        randpix = randperm(pixelCount, alpha);
        
        response = extractFilterResponses(im, filterBank);
        
        idx = (i-1)*alpha+1;
        
        
        filter_responses(idx:idx+alpha-1, :) = response(randpix, :);
        
    end
    
    
    [~, dictionary] = kmeans(filter_responses, K, 'EmptyAction', 'drop');
    
    dictionary = dictionary';
end

