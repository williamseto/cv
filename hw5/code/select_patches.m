function select_patches()

n_pos = 5;

n_neg = 100;

template_images_pos = cell(n_pos, 1);
template_images_neg = cell(n_neg, 1);

%choose random images for the user
img_idx = randperm(7,n_pos)-1;
%img_idx = [5 0 6 3 2];
pos_locations = zeros(7,2);
%generate positive examples
for i=1:length(img_idx)
    
    im = im2double(rgb2gray(imread(strcat('../data/test',num2str(img_idx(i)),'.jpg'))));
    figure(1);
    clf;
    imshow(im);

    rect = getrect(figure(1));
    x = round(rect(1));
    y = round(rect(2));
    w = round(rect(3));
    h = round(rect(4));
    
    %save positive example locations so that they don't overlap with 
    %negative examples later
    pos_locations(img_idx(i)+1, 1) = x;
    pos_locations(img_idx(i)+1, 2) = y;
    
    curr_patch = im(y:y+h, x:x+w);
    curr_patch = imresize(curr_patch, [128 128]);
    template_images_pos{i} = curr_patch;
    
    %visualize selected patch
    figure; imshow(curr_patch);  
    
end

for i=1:n_neg
   
    b_overlap = 1;
    while b_overlap == 1
        b_overlap = 0;
        
        rand_idx = randperm(7,1)-1;
        rand_im = im2double(rgb2gray(imread(strcat('../data/test',num2str(rand_idx),'.jpg'))));
        rand_x = randi([1, size(rand_im,2)-128]);
        rand_y = randi([1, size(rand_im,1)-128]);
        for j=1:n_pos
            if abs(rand_x-pos_locations(rand_idx+1,1))<128 && abs(rand_y-pos_locations(rand_idx+1,2))<128
                b_overlap = 1;
                break;
            end
        end
        
    end
    
    neg_patch = rand_im(rand_y:rand_y+127, rand_x:rand_x+127);
    template_images_neg{i} = neg_patch;
        
    
end


save('../data/template_images_pos.mat','template_images_pos')
save('../data/template_images_neg.mat','template_images_neg')


end

