function indices = expIndices(expId)

load(getDatasetMat(), 'clustersTable');

expIds = [clustersTable.Experiment];
indices = strcmp(expIds, expId);



