load(fullfile('..','data','aerialseq.mat'));

M = eye(3);

for i=1:size(frames, 3)-1    
    
    %{
    %display frame
    %warp using code from warpH
    tform = maketform( 'projective', M'); 
    warp_frame = imtransform(frames(:,:,i), tform, 'bilinear', 'XData', ...
        [1 size(frames(:,:,i),2)], 'YData', [1 size(frames(:,:,i),1)], 'Size', size(frames(:,:,i)));

    imshow(warp_frame);
    pause(0.0001)
     
    new_M = LucasKanadeAffine(frames(:,:,i), frames(:,:,i+1))
    
    M = new_M*M;
    %}
    
    mask = SubtractDominantMotion(frames(:,:,i), frames(:,:,i+1));
    imshow(imfuse(mask, frames(:,:,i)));
    pause(0.0001)
    
    
    

end

%save(fullfile('..','results','aerialseqrects.mat','rects'));
