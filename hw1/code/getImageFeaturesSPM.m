function [ h ] = getImageFeaturesSPM( layerNum, wordMap, dictionarySize )
%GETIMAGEFEATURESSPM Summary of this function goes here
%   Detailed explanation goes here

    
    
    h = zeros(dictionarySize*(4^(layerNum)-1)/3, 1);
    
    %layer 2
    blk_size2 = floor(size(wordMap)/4);
    %hists precomputed for coarser layers
    fun = @(block_struct) getImageFeatures(block_struct.data, dictionarySize);
    hists2 = blockproc(wordMap, blk_size2, fun);
    
    % fix this output incase original image was not easily divided
    hists2 = hists2(1:4*dictionarySize, 1:4);
    
    %concat layer 2
    h(1:16*dictionarySize, 1) = reshape(hists2, [], 1) .* 1/2;
    
    %layer 1
    fun_sum = @(block_struct) sum(reshape(block_struct.data, dictionarySize, []), 2);
    hists1 = blockproc(hists2, size(hists2)/2, fun_sum);
    
    %concat layer 1
    h(16*dictionarySize+1:20*dictionarySize, 1) = reshape(hists1, [], 1) .* 1/4;
    
    %layer 0
    hists0 = sum(reshape(hists1, dictionarySize, []), 2) .* 1/4;
    %concat layer 0
    h(20*dictionarySize+1:21*dictionarySize, 1) = hists0;
    
    %L1 norm
    h = h / norm(h,1);

end

