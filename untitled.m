clear
close all
loadDataset

[n_cells, n_discs, n_bins] = size(discs.psths);

figure()

for i_cell = 3:n_cells
    for i_disc = 1:n_discs

        area(discs.t_psths, squeeze(discs.psths(i_cell, i_disc, :)))
        ylim([0 15])
        hold on
        yline(discs.tresh_up(i_cell), 'r:');
        yline(discs.avg_base(i_cell), 'k:');
        yline(discs.tresh_down(i_cell), 'b:');
        scatter(discs.activations{i_cell, i_disc}, discs.tresh_up(i_cell)* ones(1, numel(discs.activations{i_cell, i_disc})), 15, 'Red', 'Filled')
        scatter(discs.suppressions{i_cell, i_disc}, discs.tresh_down(i_cell)* ones(1, numel(discs.suppressions{i_cell, i_disc})), 15, 'Blue', 'Filled')
        title(['cell#' num2str(i_cell) ' disc:' char(discs_reps(i_disc).id) ' tresh = ' num2str(discs.tresh_up(i_cell))])
        waitforbuttonpress;
        hold off;
    end
end