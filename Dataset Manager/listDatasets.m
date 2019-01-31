function listDatasets()

load(strcat(projectPath(), '/Datasets/listOfDatasets.mat'), 'datasets');
try
    load(strcat(projectPath(), '/Datasets/listOfDatasets.mat'), 'datasets');
catch
    fprintf("ERROR, no datasets available. Create one with \'createDataset\' function");
end

for i = 1:numel(datasets)
    fprintf("\t%i. %s\n", i, datasets(i).name);
end
fprintf("\n");


