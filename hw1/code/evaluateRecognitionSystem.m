
clear;

load('../dat/traintest.mat'); 
load('vision.mat');


% used for plotconfusion
predicted_labels = zeros(8, size(test_imagenames, 2));
actual_labels = zeros(8, size(test_imagenames, 2));


imagenames = strcat(['../dat/'], test_imagenames);

test_wordmaps = strcat(['../dat/'], strrep(test_imagenames, '.jpg', '.mat'));
for i=1:length(test_wordmaps)
    load(test_wordmaps{i}); 

    h = getImageFeaturesSPM(3, wordMap, size(dictionary,2));
    
    distances = distanceToSet(h, train_features);
    [~,nnI] = max(distances);
    
    label = train_labels(nnI);
    
    predicted_labels(label, i) = 1;
    actual_labels(test_labels(i), i) = 1;
    
end

plotconfusion(actual_labels, predicted_labels)
