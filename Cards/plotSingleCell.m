function plotSingleCell(cell_id)

load(getDatasetMat, 'clustersTable');
cell_N = clustersTable(cell_id).N;
cell_exp = clustersTable(cell_id).Experiment;
cell_type = clustersTable(cell_id).Type;

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
plotPSTH(cell_id);
title('PSTH');

subplot(2, 2, 2)
plotMean2Variance(cell_id);
title('Spiking-Rate Stats');

subplot(2, 2, 3)
plotTSTAs(cell_id);
title('STA');

subplot(2, 2, 4)
plotSSTAs(cell_id);
title('Receptive Field')

supertitle = {  ['Cell #' num2str(cell_id) '. ' 'Type: ' char(cell_type)];
                ['Experiment: ' char(cell_exp) ', N = ' num2str(cell_N) '.']};
            
h = suptitle(supertitle);
h.Interpreter = 'none';