function plotTrace(expId, nCell)

load(getDatasetMat(), 'cellsTable', 'tracesMat')

indices = find([cellsTable(:).experiment] == expId & [cellsTable(:).N] == nCell);
cell_index = indices(1);
trace = tracesMat(cell_index, :);

plot(trace, 'LineWidth', 1.2);
hold on
xlim([0, 503]);

title(strcat("Exp. ", expId, ", Cell #", string(nCell)'));