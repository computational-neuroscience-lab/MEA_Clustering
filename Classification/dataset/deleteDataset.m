function deleteDataset(datasetId)

load(strcat(projectPath(), '/Datasets/listOfDatasets.mat'), 'datasets', 'activeDataset');
try
    
    index = find(strcmp(datasetId, [datasets.name]));
    if length(index) == 0
        fprintf("WARNING, Datasets does not exist. Impossible to delete dataset\n");
        return
    end
    
    if activeDataset.name == datasets(index).name
       fprintf("WARNING, Datasets is active. Impossible to delete dataset (do changeDataset first)\n");
       return
    end 

    fileName = strcat(projectPath(), '/', char(datasets(index).path));
    delete(fileName);
    datasets(index) = [];

    save(strcat(projectPath(), '/Datasets/listOfDatasets.mat'), 'datasets', 'activeDataset');

catch
    fprintf("ERROR, no datasets available. Create one with \'createDataset\' function");
end

