function [ locs, desc ] = computeBrief( im, GaussianPyramid, locsDoG, k, levels, compareX, compareY )
%COMPUTEBRIEF Summary of this function goes here
%   Detailed explanation goes here

locs = zeros(size(locsDoG));
desc = zeros(size(locsDoG, 1), size(compareX, 1));

count = 1;


for i=1:size(locsDoG, 1)
    
   %top left corner of patch, hardcoded for 9x9 patch
   corner = [locsDoG(i,2)-4, locsDoG(i,1)-4];
   
   try
       %patch = im(corner(1):corner(1)+9, corner(2):corner(2)+9);
       patch = GaussianPyramid(corner(1):corner(1)+9, corner(2):corner(2)+9, locsDoG(i,3)+2);
   catch
       continue;
   end
   
   
   locs(count,:) = locsDoG(i,:);
   desc(count,:) = (patch(compareX) < patch(compareY));
   count = count + 1;
   

    
end

%truncate extra rows
locs = locs(1:count-1, :);
desc = desc(1:count-1, :);

end

