close all
clear

model = 'LNP';
session_label = 'DHMulti';
exp_id = '20170614'; 

% idx_cells = find(getDHLNPAccuracies() > .5)';
% idx_cells = find(dh_models.(model).isModeled)';
idx_cells = 1:numel(cellsTable);
path = [dataPath '/' exp_id '/processed/DH'];

for i_cell = idx_cells
    
    plotDHCellCard(cell_id, session_label, model);
    saveas(gcf, [path '/Weights/' DHMulti num2str(i_cell) '_ws'],'jpg');
    close;
    
    plotDHWeights(i_cell, session_label, model);
    saveas(gcf, [path '/Weights/' DHMulti num2str(i_cell) '_ws'],'jpg');
    close;

    plotDHPredictions(i_cell, session_label, model);
    saveas(gcf, [path '/Predictions/' DHMulti num2str(i_cell) '_pred'],'jpg');
    close;
    
    plotDHRaster(i_cell, session_label, 'single');
    saveas(gcf, [path '/Rasters/' DHMulti num2str(i_cell) '_pred'],'jpg');
    close;
    
    plotDHAccuracyCorr(i_cell, session_label, model);
    saveas(gcf, [path '/Accuracies/' DHMulti num2str(i_cell) '_acc'],'jpg');
    close;
 
end