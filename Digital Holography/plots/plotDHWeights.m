function plotDHWeights(i_cell, exp_id)

sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 255);

H1 = getHomography('dmd', 'img');
H2 = getHomography('img1', 'mea', exp_id);

[sta_2mea, staRef_2mea] = transformImage(H2*H1, sta);

spots_2mea = getDHSpotsCoordsMEA(exp_id);
[w, a, b] = getDHLNPWeights(exp_id, i_cell);
accuracy = getDHLNPAccuracies(exp_id, i_cell);

figure
ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 600;
horz = 900;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);

colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
colormap(colorMap);

imshow(ind2rgb(sta_2mea, colormap('summer')), staRef_2mea);
hold on
scatter(spots_2mea(:,1), spots_2mea(:,2), 30, w, "Filled")
axis off

colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
colormap(colorMap);
c = colorbar;
c.Label.String = 'LNP Weights';
caxis([-1 1])

title_1 = strcat("Cell #", string(i_cell), "   LNP accuracy = ",  string(accuracy));
title_2 = strcat("r = exp(aW .* I + b)   <a = ",  string(a), ",   b = ",  string(b), ">");
title({title_1, title_2})