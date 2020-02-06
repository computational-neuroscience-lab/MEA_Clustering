function plotDHFiringRates(i_cell, session_label, model, with_labels)

if ~exist('with_labels', 'var')
    with_labels = false;
end

load(getDatasetMat(), 'cellsTable');
s = load(getDatasetMat(), session_label);
n_session = s.(session_label).sessions(1);

exp_id = char(cellsTable(i_cell).experiment);

sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 255);

H1 = getHomography('dmd', 'img');
H2 = getHomography(['img' num2str(n_session)], 'mea', exp_id);

[sta_2mea, staRef_2mea] = transformImage(H2*H1, sta);

spots_2mea = getDHSpotsCoordsMEA(session_label);
w = s.(session_label).responses.single.firingRates(i_cell, :);

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

colorMap = [ones(256,1), linspace(1,0,256)' , linspace(1,0,256)'];
colormap(colorMap);
c = colorbar;
c.Label.String = [model ' Firing Rates'];

title([session_label ', Cell #' num2str(i_cell) ': RBC activations'], 'Interpreter', 'None')

xlim([-250, 750])
ylim([-250, 750])
set(gcf,'Position',[0, 0, 1000, 1200]);
