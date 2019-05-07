close all
clear

image_path = [stimPath '/DHSpots/' 'dh_spots.jpg'];

% COMPUTE HOMOGRAPHY
anchors_image =   [116, 299, 472, 521;
                   169, 301, 73, 388;
                   1, 1, 1, 1];
               
anchors_MEA =   [3, 7, 11, 12;
                 9, 6, 11, 4;
                 1, 1, 1, 1];
             
H_mea2img = anchors_MEA * pinv(anchors_image);
H_img2mea = anchors_image * pinv(anchors_MEA);

homographies_path = [stimPath '/Homographies/Homographies.mat'];
save(homographies_path, 'H_mea2img', 'H_img2mea', '-append')

% anchors_MEA_proj = H_img2mea * anchors_MEA;
% anchors_MEA_proj = anchors_MEA_proj ./ anchors_MEA_proj(3,:);
% 
% origin_proj =  H_img2mea * [8.5;8.5;1];
% origin_proj = origin_proj ./ origin_proj(3,:);
% 
% figure()
% imshow(imread(image_path))
% hold on
% scatter(anchors_image(1,:), anchors_image(2,:), 'r*')
% scatter(anchors_MEA_proj(1,:), anchors_MEA_proj(2,:), 'go')
% scatter(origin_proj(1,:), origin_proj(2,:), 'bx')
% 
% 
% % TRANSFORM DH SPOTS
% load([stimPath '/DHSpots/spots_pattern.mat'], 'FramesOrder')
% patternImage_homo = [PatternImage, ones(100,1)].';
% pattern_MEA = H_mea2img * patternImage_homo;
% pattern_MEA = pattern_MEA ./ pattern_MEA(3,:);
