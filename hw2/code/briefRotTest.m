



im1 = imread('../data/model_chickenbroth.jpg');

angles = [0:10:360];

matches = zeros(1, length(angles));

[locs1, desc1] = briefLite(im1);

for i=1:length(angles)
    
    im2 = imrotate(im1, angles(i));
    [locs2, desc2] = briefLite(im2);

    [match] = briefMatch(desc1, desc2);

    %plotMatches(im1, im2, match, locs1, locs2)

    matches(i) = size(match, 1);

    %pause

    
end

bar(angles, matches)