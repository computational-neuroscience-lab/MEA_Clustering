function createEmptyDataset(datasetId)
% datasetId = the id of this dataset (string)

try
    load([projectPath() '/Datasets/listOfDatasets.mat'], 'datasets');
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
    save([projectPath() '/Datasets/listOfDatasets.mat'], 'activeDataset', 'datasets', '-append');
catch
    save([projectPath() '/Datasets/listOfDatasets.mat'], 'activeDataset', 'datasets');
end

