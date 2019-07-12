exp_id = '20170614';
weights_cards_folder = ['/home/fran_tr/Projects/MEA_CLUSTERING/Cards/' exp_id '/DH/'];
indici = [64 36 46 57]

% thresh = .5;
% a = getDHLNPAccuracies(exp_id);
% idx_cells = find(a > thresh)';
% sum(idx_cells)

for i_cell = indici
%      plotDHWeights(i_cell, exp_id);
%     saveas(gcf, [weights_cards_folder '/DHLNP_' num2str(i_cell) '_ws'],'jpg');
%     close;
%     
%     plotSingleCell(i_cell);
%     saveas(gcf, [weights_cards_folder '/DHLNP_' num2str(i_cell) '_cell'],'jpg');
%     close;
    
    plotDHPredictions(i_cell);
    saveas(gcf, [weights_cards_folder '/DHLNP_' num2str(i_cell) '_pred'],'jpg');
    close;
end