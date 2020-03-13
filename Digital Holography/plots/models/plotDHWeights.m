function plotDHWeights(i_cell, session_label, model, with_labels)

if ~exist('with_labels', 'var')
    with_labels = false;
end

load(getDatasetMat(), 'cellsTable');
s = load(getDatasetMat(), session_label);

exp_id = char(cellsTable(i_cell).experiment);

sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 255);

H1 = getHomography('dmd', 'img');

n_session = s.(session_label).sessions(1);
H2 = getHomography(['img' num2str(n_session)], 'mea', exp_id);

[sta_2mea, staRef_2mea] = transformImage(H2*H1, sta);

spots_2mea = getDHSpotsCoordsMEA(session_label);
[w, a, b] = getDHLNPWeights(session_label, model, i_cell);
accuracy = getDHLNPAccuracies(session_label, model, i_cell);
accuracy(isnan(accuracy)) = 0;

% figure();

colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
colormap(colorMap);

img_rgb = ind2rgb(sta_2mea, colormap('summer'));
imshow(img_rgb, staRef_2mea);
hold on

scatter(spots_2mea(:,1), spots_2mea(:,2), 60, w, "Filled")
if with_labels 
    text(spots_2mea(:,1) + 1.5, spots_2mea(:,2), string(1:size(spots_2mea, 1)));
end

load(getDatasetMat, "spatialSTAs");
rf = spatialSTAs(i_cell);
rf.Vertices = transformPointsV(H2*H1, rf.Vertices);    
[x, y] = boundary(rf);
plot(x, y, 'k', 'LineWidth', 3)

axis off

colorMap = [[linspace(0,1,128)'; ones(128,1)], [linspace(0,1,128)'; linspace(1,0,128)'] , [ones(128,1); linspace(1,0,128)']];
colormap(colorMap);
c = colorbar;
c.Label.String = [model ' Weights'];
caxis([-1 1])

title_1 = strcat("Cell #", string(i_cell), "   ", model, " accuracy = ",  string(accuracy));
title_2 = strcat("r = exp(aW .* I + b)   <a = ",  string(a), ",   b = ",  string(b), ">");
title({title_1, title_2}, 'interpreter', 'none');


xlim([-150, 450])
ylim([-150, 450])
set(gcf,'Position',[0, 0, 1000, 1200]);
