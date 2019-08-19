function plotDHWeights(i_cell, exp_id)

sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 255);

H1 = getHomography('dmd', 'img');
H2 = getHomography('img1', 'mea', exp_id);

[sta_2mea, staRef_2mea] = transformImage(H2*H1, sta);

spots_2mea = getDHSpotsCoordsMEA(exp_id);
[w, a, b] = getDHLNPWeights(i_cell);
accuracy = getDHLNPAccuracies(i_cell);

figure();

colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
colormap(colorMap);

img_rgb = ind2rgb(sta_2mea, colormap('summer'));
imshow(img_rgb, staRef_2mea);
hold on
scatter(spots_2mea(:,1), spots_2mea(:,2), 50, w, "Filled")
text(spots_2mea(:,1) + 1.5, spots_2mea(:,2), string(1:size(spots_2mea, 1)))
axis off

colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
colormap(colorMap);
c = colorbar;
c.Label.String = 'LNP Weights';
caxis([-1 1])

title_1 = strcat("Cell #", string(i_cell), "   LNP accuracy = ",  string(accuracy));
title_2 = strcat("r = exp(aW .* I + b)   <a = ",  string(a), ",   b = ",  string(b), ">");

title({title_1, title_2})


xlim([0, 500])
ylim([0, 500])
set(gcf,'Position',[0, 0, 1000, 1200]);
