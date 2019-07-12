function plotSingleCell(cell_id)

load(getDatasetMat, 'clustersTable');
cell_N = clustersTable(cell_id).N;
cell_exp = clustersTable(cell_id).Experiment;
cell_type = clustersTable(cell_id).Type;

figure('Name', ['Cell_#' char(cell_id)]);

ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 900;
horz = 1200;
set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);

subplot(2, 2, 1)
plotPSTH(cell_id);
title('psth');

subplot(2, 2, 2)
plotMean2Variance(cell_id);
title('mean 2 variance');

subplot(2, 2, 3)
plotTSTAs(cell_id);
title('sta');

subplot(2, 2, 4)
plotSSTAs(cell_id);
title('receptive field')

supertitle = {  ['Cell #' num2str(cell_id) '. ' 'Type: ' char(cell_type)];
                ['Experiment: ' char(cell_exp) ', N = ' num2str(cell_N) '.']};
            
h = suptitle(supertitle);
h.Interpreter = 'none';