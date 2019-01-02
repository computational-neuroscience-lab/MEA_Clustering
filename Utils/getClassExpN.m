function Ns = getClassExpN(classId, expId)
load(getDatasetMat(), 'cellsTable')
indices = classIndices(classId) & expIndices(expId);
Ns = [cellsTable(indices).N];
