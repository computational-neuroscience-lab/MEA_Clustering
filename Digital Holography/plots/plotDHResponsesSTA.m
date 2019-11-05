function plotDHResponsesSTA(i_cell, exp_id)

load(getDatasetMat, 'dh');

sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 255);

H1 = getHomography('dmd', 'img');
H2 = getHomography('img2', 'mea', exp_id);

[sta_2mea, staRef_2mea] = transformImage(H2*H1, sta);

spots_2mea = getDHSpotsCoordsMEA(exp_id);
w = dh.responses.singles.firingRates(i_cell, :);

figure();

colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
colormap(colorMap);

img_rgb = ind2rgb(sta_2mea, colormap('summer'));
imshow(img_rgb, staRef_2mea);
hold on
scatter(spots_2mea(:,1), spots_2mea(:,2), 75, w, "Filled")
% text(spots_2mea(:,1) + 1.5, spots_2mea(:,2), string(1:size(spots_2mea, 1)))
axis off

colormap([ones(256,1) linspace(1, 0.3,256)' linspace(1, 0.3,256)']);
c = colorbar;
c.Label.String = 'Induced Firing Rate (Hz)';
caxis([0, 15])
title(strcat("Cell #", string(i_cell)))

% 
% xlim([0, 500])
% ylim([0, 500])
xlim([-250, 750])
ylim([-250, 750])
set(gcf,'Position',[0, 0, 1000, 1200]);
