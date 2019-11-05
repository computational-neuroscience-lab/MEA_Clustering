function classesTable = buildClassesTable()

loadDataset();

classNames = getLeafClasses();
nClasses = length(classNames);

classesTable = struct(  'name',     cell(1, nClasses), ...
                        'size',     cell(1, nClasses), ...
                        'SNR',  cell(1, nClasses), ...
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


    classesTable(iClass).STD = std(mean(psths(indices, :)));
    classesTable(iClass).SNR = doSNR(psths(indices, :));
    classesTable(iClass).indices = indices;
end

% [~, ii] = sort([classesTable.STD]);
% classesTable = classesTable(ii);

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
