function plotDHSpotsRF(i_cell, exp_id, idx_spots)

load(getDatasetMat, 'spatialSTAs');
H1 = getHomography('dmd', 'img');
H2 = getHomography('img2', 'mea', exp_id);

sta = getSTAFrame(i_cell);
sta = floor(sta/max(sta(:)) * 255);

rf = spatialSTAs(i_cell);
rf.Vertices = transformPointsV(H2*H1, rf.Vertices);

spots_2mea = getDHSpotsCoordsMEA(exp_id);
w = flip(getColors(length(idx_spots)));

hold on
    
[x, y] = boundary(rf);
plot(x, y, 'k', 'LineWidth', 2)
    
scatter(spots_2mea(idx_spots,1), spots_2mea(idx_spots,2), 50, w(idx_spots, :), "Filled")
title(strcat("Cell #", string(i_cell)))

xlim([-100, 600])
ylim([-100, 600])
pbaspect([1 1 1])
set(gcf,'Position',[0, 0, 1000, 1200]);
