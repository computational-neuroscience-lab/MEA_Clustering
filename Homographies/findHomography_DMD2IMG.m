close all
clear

image_path = [stimPath '/DHSpots/' 'dh_spots.jpg'];

camera_img = imread(image_path);
[camera_height, camera_width, ~] = size(camera_img);

load(getDatasetMat, "stas");
[dmd_height, dmd_width, ~] = size(stas{1});

DMD_PxlSize = 50; 
Camera_PxlSize = 0.64;

s = DMD_PxlSize/Camera_PxlSize;
r = -pi/2;

t_height = (camera_height - dmd_height) / 2;
t_width = (camera_width - dmd_width) / 2;

H1 = [1, 0, 0; ...
      0, 1, 0; ...
      0, 0, 1];
         
H2 = [+s*cos(r), -s*sin(r), 0; ...
      +s*sin(r), +s*cos(r), 0; ...
      0,         0,         1];

H_dmd2img = H2;
H_img2dmd = inv(H_dmd2img);

homographies_path = [projectPath '/Homographies/Homographies.mat'];
save(homographies_path, 'H_dmd2img', 'H_img2dmd', '-append')
