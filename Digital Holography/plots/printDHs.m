close all
clear

exp_id = '20170614';
weights_cards_folder = ['/home/fran_tr/Projects/MEA_CLUSTERING/Cards/' exp_id '/DH/'];

thresh = .5;
a = getDHLNPAccuracies();
idx_cells = find(a > thresh)';

for i_cell = idx_cells
     plotDHWeights(i_cell, exp_id);
    saveas(gcf, [weights_cards_folder '/weights/DHLNP_' num2str(i_cell) '_ws'],'jpg');
    close;
    
    plotSingleCell(i_cell);
    saveas(gcf, [weights_cards_folder '/cells/DHLNP_' num2str(i_cell) '_cell'],'jpg');
    close;
    
    plotDHPredictions(i_cell);
    saveas(gcf, [weights_cards_folder '/predictions/DHLNP_' num2str(i_cell) '_pred'],'jpg');
    close;
    
    plotDHAccuracy(i_cell);
    saveas(gcf, [weights_cards_folder '/accuracies/DHLNP_' num2str(i_cell) '_acc'],'jpg');
    close;
end