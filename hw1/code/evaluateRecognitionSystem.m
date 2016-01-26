
clear;

load('../dat/traintest.mat'); 
load('vision.mat');

C = zeros(8,8);

correct = 0;

imagenames = strcat(['../dat/'], test_imagenames);

test_wordmaps = strcat(['../dat/'], strrep(test_imagenames, '.jpg', '.mat'));
for i=1:length(test_wordmaps)
    load(test_wordmaps{i}); 
    
    %h = getImageFeatures(wordMap, size(dictionary, 2));
    h = getImageFeaturesSPM(3, wordMap, size(dictionary,2));
    
    distances = distanceToSet(h, train_features);
    [~,nnI] = max(distances);
    
    label = train_labels(nnI);
    
    if label == test_labels(i)
        correct = correct + 1;
    end
    
    C(test_labels(i), label) = C(test_labels(i), label) + 1;
    i
end

correct / length(test_imagenames)
