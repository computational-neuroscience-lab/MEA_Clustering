function plotDHWeights_RF(i_cell, experiment)

DMD_PxlSize = 50; 
Camera_PxlSize = 0.64;                        

camera_img = imread([stimPath '/DHSpots/' 'dh_spots.jpg']);
[camera_height, camera_width, ~] = size(camera_img);

load(getDatasetMat, "stas");
smoothSTA = smoothSta(stas{i_cell});
staFrame = std(smoothSTA, [], 3);

s = DMD_PxlSize/Camera_PxlSize;
r = -90;

transformed_sta = staFrame;
transformed_sta = imrotate(transformed_sta, r, 'nearest');
transformed_sta = imresize(transformed_sta, s, 'nearest');

h = getHomography('dmd', 'img');
t = maketform('projective', transpose(h));
ttt_sta = imtransform(staFrame, t);

[transf_sta_height, transf_sta_width] = size(transformed_sta);
t_height = (camera_height - transf_sta_height) / 2;
t_width = (camera_width - transf_sta_width) / 2;

load([dataPath '/' char(experiment) '/processed/DHSpots/DHSpots_coords.mat'], "spots_coords_image");
load("ws_array.mat", "ws", "a", "b");
load(getDatasetMat, "dh_stats")

figure
imagesc(ttt_sta);

figure
imagesc(transformed_sta, ...
       'YData', [t_height  t_height + transf_sta_height], ...
       'XData', [t_width   t_width + transf_sta_width]);
hold on

title_1 = strcat("Cell #", string(i_cell), "   LNP accuracy = ",  string(dh_stats.accuracies(i_cell)));
title_2 = strcat("r = exp(aW .* I + b)   <a = ",  string(a(i_cell)), ",   b = ",  string(b(i_cell)), ">");

ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 600;
horz = 900;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);

suptitle({title_1, title_2})
colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
colorCodes = ceil(ws(i_cell,:)*127.5 + 128.5);
colors = colorMap(colorCodes, :);
scatter(spots_coords_image(:,1), spots_coords_image(:,2), 30, colors, "Filled")
% axis off


