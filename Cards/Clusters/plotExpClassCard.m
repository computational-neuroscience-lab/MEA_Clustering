function classNotEmpty = plotExpClassCard(classId, expId)

indices = and(classIndices(classId), expIndices(expId));
classNotEmpty = sum(indices>0);

if classNotEmpty
    plotExpIndicesCard(indices);
    h = suptitle(['Class ' char(classId) ', Exp. ' char(expId)]);
    h.Interpreter = 'None';
else
    fprintf("INFO: no cells of type %s in experiment #%s\n", classId, expId);
end

