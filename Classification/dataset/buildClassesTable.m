function classesTable = buildClassesTable()

loadDataset();

classNames = unique([clustersTable.Type]);
nClasses = length(classNames);

classesTable = struct(  'name',     cell(1, nClasses), ...
                        'size',     cell(1, nClasses), ...
                        'avgSTD',  cell(1, nClasses), ...
                        'indices',  cell(1, nClasses) ...
                     );
for iClass = 1:numel(classNames)
    name = classNames(iClass);
    indices = classIndices(name);
    
    setResponses = tracesMat(indices, :);
    stdResponse = std(setResponses, [], 1);
    avgSTD = mean(stdResponse);

    classesTable(iClass).name = classNames(iClass);
    classesTable(iClass).size = sum(indices);
    classesTable(iClass).avgSTD = avgSTD;
    classesTable(iClass).indices = indices;

end

classesTableNotPruned = classesTable;

% remove pruned
pruneds = logical(zeros(nClasses, 1));
for iClass = 1:nClasses
    if endsWith(classesTable(iClass).name, "_PRUNED.")
        pruneds(iClass) = true;
    end
end
classesTable(pruneds) = [];

save(getDatasetMat, 'classesTable', 'classesTableNotPruned', '-append');    
