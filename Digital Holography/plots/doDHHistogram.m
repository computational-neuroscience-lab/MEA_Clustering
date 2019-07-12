function doDHHistogram(i_cell)

% Load PSTHS
load(getDatasetMat(), "dh", "dh_stats", "cellsTable");

rep_pattern2psth = squeeze(dh.responses.repeated.psth(i_cell, :, dh.bin_init:dh.bin_end));
sin_pattern2psth = squeeze(dh.responses.singles.psth(i_cell, :, dh.bin_init:dh.bin_end));
rep_pattern_avgRate = mean(rep_pattern2psth, 2);
sin_pattern_avgRate = mean(sin_pattern2psth, 2);

exp_id = char(cellsTable(i_cell).experiment);
load([dataPath '/' exp_id '/processed/DH/DHLNP/keras_predictions.mat'], 'pred_rep', 'pred_sin')

rep_pattern_prediction = squeeze(pred_rep(i_cell, :, :));
sin_pattern_prediction = squeeze(pred_sin(i_cell, :, :));

subplot(1, 2, 1);
barh([sin_pattern_avgRate, sin_pattern_prediction])
xlabel("mean spiking rate");
yticks(1:length(sin_pattern_avgRate));
ylabel("DH pattern ID");
title("single spot mean activation");
legend("cell recordings", "model prediction");

subplot(1, 2, 2);
barh([rep_pattern_avgRate, rep_pattern_prediction])
xlabel("mean spiking rate");
yticks(1:length(rep_pattern_avgRate));
title("multi spot mean activation");
legend("cell recordings", "model prediction");

accuracy = dh_stats.accuracies(i_cell);
title_1 = strcat("Cell #", string(i_cell), "   LNP accuracy = ",  string(accuracy));
suptitle(title_1);
