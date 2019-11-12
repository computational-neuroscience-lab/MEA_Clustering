function createDataset(datasetId, expIds, cellsIds, traces)
% datasetId = the id of this dataset (string)
% expIds = a cell array containing the ids of each experiment (strings)
% traces = a struct containing the traces for each experiment {n_exp x [n_cell x n_step]}

createEmptyDataset(datasetId)
[cellsTable, tracesMat] = buildDatasetTable(expIds, cellsIds, traces);
save(getDatasetMat, 'cellsTable', 'tracesMat');


