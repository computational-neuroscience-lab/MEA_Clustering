function createDataset(datasetId, expIds, cellsIds, traces)
% datasetId = the id of this dataset (string)
% expIds = a cell array containing the ids of each experiment (strings)
% traces = a struct containing the traces for each experiment {n_exp x [n_cell x n_step]}


try
    load(strcat(projectPath(), '/Datasets/listOfDatasets.mat'), 'datasets');
catch
    datasets = struct('name', {}, 'path', {});
end

% if the dataset already existed, overwrite it
if sum(strcmp(datasetId, [datasets.name])) > 0
    fprintf("WARNING, Dataset with this name already exists. Overwriting dataset\n");
    nRow = find(strcmp(datasetId, [datasets.name]));
else
    nRow = numel(datasets) + 1;
    datasets(nRow).name = datasetId;
    datasets(nRow).path = strcat("Datasets/", datasetId, "Matrix.mat");
end

activeDataset = datasets(nRow);
try
    save(strcat(projectPath(), '/Datasets/listOfDatasets.mat'), 'activeDataset', 'datasets', '-append');
catch
    save(strcat(projectPath(), '/Datasets/listOfDatasets.mat'), 'activeDataset', 'datasets');
end

[cellsTable, tracesMat] = buildDatasetTable(expIds, cellsIds, traces);
save(getDatasetMat, 'cellsTable', 'tracesMat');


