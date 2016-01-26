function [ histInter ] = distanceToSet( wordHist, histograms )
%DISTANCETOSET Summary of this function goes here
%   Detailed explanation goes here

    %fun = @(X, Y) ((X-Y).^2)./ X;
    
    histInter = sum(bsxfun(@min, histograms, wordHist));

    %wordHist = repmat(wordHist, 1, size(histograms, 2));
    
    %histInter = sum(((wordHist-histograms).^2)./histograms);

end

