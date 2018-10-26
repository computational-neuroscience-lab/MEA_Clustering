function plotSetCluster(typeId, indices, condText, pcaSpaceID)
% TODO: check why it does not work

if ~exist('condText','var')
    condText = "Condition";
end

if ~exist('pcaSpaceID','var')
    % assume all the classes are from the same pca space
    pcaSpaceID = getPCASpace(typeId);
end

load(getDatasetMat, 'PCAs');
pcaSpace = {PCAs.(pcaSpaceID)};


text = strcat(typeId, " cells in 3 principal components from ", pcaSpaceID, " space");
figure('Name', text);
   
condIndices = and(classIndices(typeId), indices);
notCondIndexes = and(classIndices(typeId), ~indices);

condPCs = cell2mat(pcaSpace(condIndices)');
notCondPCs = cell2mat(pcaSpace(notCondIndexes)');

hold on   
scatter3(condPCs(:, 1), condPCs(:, 2), condPCs(:, 3), 'r', 'filled');
scatter3(notCondPCs(:, 1), notCondPCs(:, 2), notCondPCs(:, 3), 'b', 'filled');
hold off

 legend([condText, strcat("Not ", condText)])
 title(text);