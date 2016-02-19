function [ ] = ec_1(  )
%EC_1 Summary of this function goes here
%   Detailed explanation goes here

im1 = imread('../data/model_chickenbroth.jpg');


angles = [0:10:360];

matches = zeros(1, length(angles));

[locs1, desc1] = briefLite_Rot(im1);


for i=1:length(angles)
    
    im2 = imrotate(im1, angles(i), 'bilinear');

    [locs2, desc2] = briefLite_Rot(im2);

    [match] = briefMatch(desc1, desc2);
    

    %plotMatches(im1, im2, match, locs1, locs2)

    matches(i) = size(match, 1);

    %pause
    
end

bar(angles, matches)


end


function [ locs, desc ] = briefLite_Rot( im )

sigma0 = 1;
k = sqrt(2);
levels = [-1 0 1 2 3 4];
th_contrast = 0.03;
th_r = 12;


%get keypoints
[locsDoG, gp] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r);

%precompute gradient magnitude and orientation
magnitude = {};
orientation = {};
%only do first 5, since we will associate the kp with the sigma 
%of the "lower" image
for i=1:length(levels)
    
    [Dx, Dy] = gradient(gp(:,:,i));
    magnitude{i} = sqrt(Dx.*Dx + Dy.*Dy);
    orientation{i} = atan2(Dy, Dx);
    
end

load('testPattern.mat')


locs = zeros(size(locsDoG));
desc = zeros(size(locsDoG, 1), size(compareX, 1));

count = 1;

for i=1:size(locsDoG, 1)
    
    %15 x 15 patch to accomodate rotation
    corner = [locsDoG(i,2)-7, locsDoG(i,1)-7];
    
    try
        patch = gp(corner(1):corner(1)+14, corner(2):corner(2)+14, locsDoG(i,3)+2);
    catch
        continue;
    end
    
    %attempt orientation compensation
    
    %create histogram for this keypoint
    hist = zeros(36,1);
    
    %create a gaussian weighting window for the patch    
    sigma = sigma0*k^(locsDoG(i,3)+1);
    window_range = [-7:7];
    [Y, X] = meshgrid(window_range, window_range);
    window = exp( -(X.^2 + Y.^2)/(2*sigma^2) );
    
    %calculate weight for the patch
    mag = magnitude{locsDoG(i,3)+2};
    ori = orientation{locsDoG(i,3)+2};
    weight = mag(corner(1):corner(1)+14, corner(2):corner(2)+14) .* window;
    
    ori = ori(corner(1):corner(1)+14, corner(2):corner(2)+14);
    %find closest bin for the orientations
    ori = ceil((ori+pi)*18/pi);
    
    %fill histogram with weights
    for ox=1:size(ori,1)
        for oy=1:size(ori,2)
            hist(ori(ox,oy)) = hist(ori(ox,oy)) + weight(ox,oy);
        end
    end
    
    %find highest peak/ most likely orientation
    [~, bin] = max(hist);
    
    theta = (bin-1)*10;
    
    %rotate patch to compensate
    patch = imrotate(patch, -theta, 'bilinear');
    %resize to 9x9
    patch = patch(round(size(patch,1)/2)-4:round(size(patch,1)/2)+4, round(size(patch,2)/2)-4:round(size(patch,2)/2)+4);
    
    locs(count,:) = locsDoG(i,:);
    desc(count,:) = (patch(compareX) < patch(compareY));
    count = count + 1;
    
end

%truncate extra rows
locs = locs(1:count-1, :);
desc = desc(1:count-1, :);


end

