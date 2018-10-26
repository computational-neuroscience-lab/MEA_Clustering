function classifySimple(datasetId, cellsIds, traces)

createDataset(datasetId, {datasetId}, {cellsIds}, {traces});
treeClassification();
buildClassesTable();