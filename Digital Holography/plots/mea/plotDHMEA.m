function plotDHMEA(exp_id, session_label)
l_elec = 30;  % units

session_struct = load(getDatasetMat, session_label);
i_session = session_struct.(session_label).sessions(1);

% COMPUTE HOMOGRAPHY             
H_img2mea = getHomography(['img' num2str(i_session)], 'mea', exp_id);
img_path = [dataPath '/' exp_id '/processed/DH/' 'mea' num2str(i_session) '.jpg'];
camera_img = imread(img_path);
[camera_img_proj, camera_mea_ref] = transformImage(H_img2mea, camera_img);

% PLOTTING TRANSFORMED POINTS
figure()

imshow(camera_img_proj, camera_mea_ref)
hold on


axis on
xticks(1:l_elec:l_elec*16)
xticklabels(0:15)
yticks(1:l_elec:l_elec*16)
yticklabels(0:15)
title("MEA Coordinates")


% ADD DH POINTS
points = getDHSpotsCoordsMEA(exp_id, session_label);
scatter(points(:,1), points(:,2), 50, 'r', 'filled')
text(points(:,1) + 2, points(:,2), string(1:size(points, 1)))
