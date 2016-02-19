function [ compareX, compareY ] = makeTestPattern( patchWidth, nbits )
%MAKETESTPATTERN Summary of this function goes here
%   Detailed explanation goes here

maxind = patchWidth^2;

%sample uniform
compareX = randi(maxind, [nbits 1]);
compareY = randi(maxind, [nbits 1]);


end

