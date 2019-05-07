function plotClassCard(typeId, experiments)

if ~exist('experiments', 'var')
    load(getDatasetMat(), 'experiments');
end

indices = classIndices(typeId);
figName = strcat("Class ", typeId);

plotIndicesCard(figName, indices, experiments);