function copyDataset(datasetId, copyId)

% load the list of datasets
try
    load(strcat(projectPath(), '/Datasets/listOfDatasets.mat'), 'datasets');
catch
    fprintf("ERROR, no datasets available. Create one with \'createDataset\' function");
    return
end

% load the dataset to copy
index = find(strcmp(datasetId, [datasets.name]));
if length(index) == 0
    fprintf("WARNING, Datasets does not exist. Impossible to change dataset\n");
	return
end

datasetPath = strcat(projectPath(), "/", datasets(index).path);
copyPath = strcat("Datasets/", copyId, "Matrix.mat");

% make sure copyId does not exist already.
if sum(strcmp(copyId, [datasets.name])) > 0
    fprintf("ERROR, Dataset with this name already exists.\n");
    return
% make the copy and update the list
else 
    
    copyfile(char(datasetPath), char(strcat(projectPath(), "/", copyPath)))
    nRow = numel(datasets) + 1;
    datasets(nRow).name = copyId;
    datasets(nRow).path = copyPath;
end

save(strcat(projectPath(), '/Datasets/listOfDatasets.mat'), 'datasets', '-append');


