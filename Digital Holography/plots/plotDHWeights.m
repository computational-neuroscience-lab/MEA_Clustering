function plotDHWeights(i_cell)

load(strcat(stimPath, "/DHSpots/spots_coords.mat"), "spots_coords_image");
load("ws_array.mat", "ws", "a", "b");

load(getDatasetMat, "dh_stats")

figure()
background = imread(char(strcat(stimPath, "/DHSpots/dh_spots.jpg")));
imshow(background)
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
scatter(spots_coords_image(:,1), spots_coords_image(:,2), 30, ws(i_cell,:), "Filled")
axis off

colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
colormap(colorMap);
c = colorbar;
c.Label.String = 'LNP Weights';
caxis([-1 1])
