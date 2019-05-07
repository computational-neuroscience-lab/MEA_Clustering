close all
clear

i_cell = 43;
experiment = '20170614';
image_path = [stimPath '/DHSpots/' 'dh_spots.jpg'];
img = imread(image_path);

load(getDatasetMat, "stas");
smoothSTA = smoothSta(stas{i_cell});
staFrame = std(smoothSTA, [], 3);

load([dataPath '/' char(experiment) '/processed/DHSpots/DHSpots_coords.mat'], "spots_coords_image");

h = getHomography('img', 'dmd');
spots_hcoords_dmd = h * [spots_coords_image.'; ones(1, 100)];

spots_x_dmd = spots_hcoords_dmd(1, :) ./ spots_hcoords_dmd(3, :);
spots_y_dmd = spots_hcoords_dmd(2, :) ./ spots_hcoords_dmd(3, :);
spots_coords_dmd = [spots_x_dmd; spots_y_dmd].';

close all
figure()
hold on
% scatter(spots_coords_image(:,1), spots_coords_image(:,2), 30, "Filled")
scatter(spots_coords_dmd(:,1), spots_coords_dmd(:,2), 30, "Filled")
% imagesc(staFrame);

