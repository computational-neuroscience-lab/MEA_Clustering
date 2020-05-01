function classesTable = buildClassesTable()

loadDataset();

classNames = unique([clustersTable.Type]);
nClasses = length(classNames);

classesTable = struct(  'name',     cell(1, nClasses), ...
                        'size',     cell(1, nClasses), ...
                        'indices',  cell(1, nClasses) ...
                     );
for iClass = 1:numel(classNames)
    name = classNames(iClass);
    indices = classIndices(name);
    
    classesTable(iClass).name = classNames(iClass);
    classesTable(iClass).size = sum(indices);
    
    classesTable(iClass).PSTH = mean(psths(indices, :));
    classesTable(iClass).STA = mean(temporalSTAs(indices, :));
    
    if   abs(max(classesTable(iClass).STA)) > abs(min(classesTable(iClass).STA))
        classesTable(iClass).POLARITY = "ON";
    else
        classesTable(iClass).POLARITY = "OFF";
    end

    classesTable(iClass).SNR_PSTH = doSNR(psths(indices, :));
    classesTable(iClass).SNR_STA = doSNR(temporalSTAs(indices, :));
    classesTable(iClass).indices = indices;
end

% [~, ii] = sort([classesTable.STD]);
% classesTable = classesTable(ii);

classesTableNotPruned = classesTable;

% remove pruned
pruned = logical(zeros(nClasses, 1));
for iClass = 1:nClasses
    pruned(iClass) = endsWith(classesTable(iClass).name, "_PRUNED.");
end
classesTable(pruned) = [];

save(getDatasetMat, 'classesTable', 'classesTableNotPruned', '-append');    
