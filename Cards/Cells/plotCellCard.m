function plotCellCard(cell_id)


load(getDatasetMat, 'cellsTable', 'clustersTable');

cell_N = cellsTable(cell_id).N;
cell_exp = char(cellsTable(cell_id).experiment);
if exist('clustersTable', 'var')
    cell_type = clustersTable(cell_id).Type;
else
    cell_type = 'unknown';
end

figure('Name', ['Cell_#' char(cell_id)]);

subplot(2, 3, [1 2])
plotPSTH(cell_id);

title('Euler PSTH');

subplot(2, 3, 4)
plotISICell(cell_id)
title('ISI');

subplot(2, 3, 5)
plotTSTAs(cell_id);
title('STA');

subplot(2, 3, [3, 6])
plotSSTAs(cell_id);
title('Receptive Field');

supertitle = {  ['Cell #' num2str(cell_id) '. ' 'Type: ' char(cell_type)];
                ['Experiment: ' char(cell_exp) ', N = ' num2str(cell_N) '.']};
            
h = suptitle(supertitle);
h.Interpreter = 'none';

fullScreen();
