function tl_detect_script


ndet = 5;
scale = [];

load('../data/template_images_pos.mat');
load('../data/template_images_neg.mat');

Itest = im2double(rgb2gray(imread('../data/test2.jpg')));


% template = tl_pos(template_images_pos);
% [x,y,score] = detect(Itest,template,ndet);
% draw_detection(Itest, ndet, x, y, scale);


template = tl_pos_neg(template_images_pos, template_images_neg);
[x,y,score] = detect(Itest,template,ndet);
draw_detection(Itest, ndet, x, y, scale);


% lambda = 0.45;
% template = tl_lda(template_images_pos, template_images_neg, lambda);
% %[x,y,score] = detect(Itest,template,ndet);
% %draw_detection(Itest, ndet, x, y, scale);
% 
% det_res = multiscale_detect(Itest, template, ndet);
% draw_detection(Itest, ndet, det_res(:,1), det_res(:,2), det_res(:,3));

end

function draw_detection(Itest, ndet, x, y, scale)

% please complete this function to show the detection results

%display top ndet detections
figure; imshow(Itest);
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  hold on; 
  
  %check if doing multi-scale
  if isempty(scale)
      h = rectangle('Position',[x(i)-64 y(i)-64 128 128],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]);
  else
      %calculate unscaled x,y, and bbox size
      curr_x = round(x(i)/scale(i));
      curr_y = round(y(i)/scale(i));
      bbox_size = 128/scale(i);
      h = rectangle('Position',[curr_x-(bbox_size/2), curr_y-(bbox_size/2) bbox_size bbox_size],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
  end
  hold off;
end

end