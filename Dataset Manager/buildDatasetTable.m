function [cellsTable, tracesMat] = buildDatasetTable(expIds, cellsIds, expTraces, grades)
% expIds = a cell array containing the ids of each experiment (strings)
% expTraces = a struct containing the traces for each experiment {n_exp x [n_cell x n_step]}

cellsTable = {};
tracesMat = [];
cellCount = 1;

for iExp = 1:numel(expIds)
    
    expId = expIds{iExp};
    traces = expTraces{iExp};
    ids = cellsIds{iExp};
    
    for n = 1:size(traces,1)
        cellsTable(cellCount).experiment = string(expId);
        cellsTable(cellCount).N = ids(n);
        cellsTable(cellCount).Grade = grades(n);
        tracesMat(cellCount, :) = traces(n, :);
        cellCount = cellCount + 1;
        n = n + 1;
    end
end

