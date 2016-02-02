
clear;

load('../dat/traintest.mat'); 
load('dictionary.mat');

dictionarySize = size(dictionary, 2);


%read wordmaps generated and extract features

train_features = zeros(dictionarySize*(4^3-1)/3, length(train_imagenames));

train_wordmaps = strcat(['../dat/'], strrep(train_imagenames, '.jpg', '.mat'));
for i=1:length(train_wordmaps)
    load(train_wordmaps{i}); 
    
    train_features(:, i) = getImageFeaturesSPM(3, wordMap, dictionarySize);
    
    
end

save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels'); 