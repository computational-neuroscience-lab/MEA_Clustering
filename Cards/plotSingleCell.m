function plotSingleCell(cell_id)

load(getDatasetMat, 'cellsTable', 'clustersTable');
load(getDatasetMat, 'spatialSTAs');
load(getDatasetMat, 'spikes', 'params');

cell_N = cellsTable(cell_id).N;
cell_exp = char(cellsTable(cell_id).experiment);

if exist('clustersTable', 'var')
    cell_type = clustersTable(cell_id).Type;
else
    cell_type = 'unknown';
end
load([dataPath() '/' cell_exp, '/processed/CheckerBoard/Checkerboard_RepetitionTimes.mat'], 'rep_begin', 'rep_end')



figure('Name', ['Cell_#' char(cell_id)]);
try
    ss = get(0,'MonitorPositions'); % try to get the secondary monitor
    x_0 = ss(2, 1);
    y_0 = ss(2, 2);
    width = ss(2, 3);
    height = ss(2, 4);
    set(gcf,'Position',[x_0, y_0, width, height]);
catch
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    set(gcf,'Position',[0, 0, width, height]);
end

subplot(2, 2, 1)
% plotPSTH(cell_id);
plotRaster(cell_id, spikes, rep_begin, rep_end, params.meaRate, 0)

title('Raster');

subplot(2, 2, 2)
plotISICell(cell_id)
title('ISI');

subplot(2, 2, 3)
plotTSTAs(cell_id);
title('STA');

subplot(2, 2, 4)
imagesc(getSTAFrame(cell_id, true));
[x, y] = boundary(spatialSTAs(cell_id));
hold on
plot(x, y, 'r', 'LineWidth', 3)

title('Receptive Field')

supertitle = {  ['Cell #' num2str(cell_id) '. ' 'Type: ' char(cell_type)];
                ['Experiment: ' char(cell_exp) ', N = ' num2str(cell_N) '.']};
            
h = suptitle(supertitle);
h.Interpreter = 'none';