function id = getDatasetId()
try
    load(strcat(projectPath(), '/Datasets/listOfDatasets.mat'), 'activeDataset');
    id = activeDataset.name;
catch
    fprintf("ERROR, no datasets available. Create one with \'createDataset\' function");
end


