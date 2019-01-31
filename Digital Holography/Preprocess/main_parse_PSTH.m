close all

load(getDatasetMat(), 'dh_PSTHs');
load(getDatasetMat(), 'cellsTable');

% activating_patterns = dh_PSTHs(:, :, 1) < dh_PSTHs(:, :, 2);
% cells_activations = sum(activating_patterns, 2);
% 
% [~, max_activated_cells] = sort(cells_activations, 'descend');

for i_cell = 1:size(dh_PSTHs, 1)
    figure
    image(squeeze(dh_PSTHs(i_cell, :, :) * 2.5));
    colormap jet
    axis off
    title(strcat("DH Activation - Cell #", string(cellsTable(i_cell).N)));
    waitforbuttonpress
end
