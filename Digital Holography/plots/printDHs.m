close all
clear

model = "LNP";
load(getDatasetMat(), "experiments");
load(getDatasetMat(), "dh_models");
load(getDatasetMat(), "cellsTable");

assert(numel(experiments) == 1)
exp_id = char(experiments{1});
path = [dataPath '/' exp_id '/processed/DH'];

thresh = .5;
% a = getDHLNPAccuracies();
% idx_cells = find(a > thresh)';
% idx_cells = find(dh_models.(model).isModeled)';
idx_cells = [12 13 22 42 44];

for i_cell = idx_cells
     plotDHWeights(i_cell, exp_id, model);
    saveas(gcf, [path '/Weights/DH_' num2str(i_cell) '_ws'],'jpg');
    close;
%     
    plotSingleCell(i_cell);
    saveas(gcf, [path '/Cells/DH_' num2str(i_cell) '_cell'],'jpg');
    close;
%     
%     plotDHPredictions(i_cell, model);
%     saveas(gcf, [path '/Predictions/DH_' num2str(i_cell) '_pred'],'jpg');
%     close;
    
%     plotDHRaster(i_cell);
%     saveas(gcf, [path '/Rasters/DH_' num2str(i_cell) '_pred'],'jpg');
%     close;
    
%     plotDHAccuracy(i_cell, model);
%     saveas(gcf, [path '/Accuracies/DH_' num2str(i_cell) '_acc'],'jpg');
%     close;
    
%     plotDHResponsesSTA(i_cell, exp_id);
%     saveas(gcf, [path '/Activation/DH_' num2str(i_cell) '_activation'],'jpg');
%     close;
end