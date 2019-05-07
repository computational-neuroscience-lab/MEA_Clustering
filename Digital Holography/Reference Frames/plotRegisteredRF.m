
i_cell = 43;
DMD_PxlSize = 50; 
Camera_PxlSize = 0.64;                        

camera_img = imread([stimPath '/DHSpots/' 'dh_spots.jpg']);
[camera_height, camera_width, ~] = size(camera_img);

load(getDatasetMat, "stas");
smoothSTA = smoothSta(stas{i_cell});
staFrame = std(smoothSTA, [], 3);

% Transoformation from CAMERA 2 DMD
s = DMD_PxlSize/Camera_PxlSize;
r = -90;

transformed_sta = imresize(staFrame, s, 'nearest');
transformed_sta = imrotate(transformed_sta, r, 'nearest');

[transf_sta_height, transf_sta_width] = size(transformed_sta);
t_height = (camera_height - transf_sta_height) / 2;
t_width = (camera_width - transf_sta_width) / 2;

figure
imagesc(staFrame)
title("receptive Field")

figure
imagesc(transformed_sta);
title("transformed receptive Field")

figure
imagesc(camera_img);
title("camera img")

figure
imagesc(transformed_sta, ...
        'YData', [t_height  t_height + transf_sta_height], ...
        'XData', [t_width   t_width + transf_sta_width]);
hold on
imagesc(camera_img);
title("composite")

% In the end you get a STA in an extended picture where the center of the
% picture is the same as any other camera picture, and pixel size and
% orientation are 
% also the same. To display them together you just have to center them in
% the same place. They don't have the same size because the DMD display
% area is larger than the camera field of view. 

