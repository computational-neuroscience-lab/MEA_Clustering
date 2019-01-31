function initializeDataset()
datasets = struct('name', {}, 'path', {});
activeDataset = struct('name', {}, 'path', {});

mkdir(strcat(projectPath(), '/Datasets'))
save(strcat(projectPath(), '/Datasets/listOfDatasets.mat'),  'datasets', 'activeDataset');
