function plotDHPredictions(i_cell)

% Load PSTHS
load(getDatasetMat(), "dh", "dh_stats", "cellsTable");

rep_pattern2psth = squeeze(dh.responses.repeated.psth(i_cell, :, dh.bin_init:dh.bin_end));
rep_pattern_avgRate = mean(rep_pattern2psth, 2);

rep_pattern_prediction = squeeze(dh_stats.predictions(i_cell, :, :));
accuracy = dh_stats.accuracies(i_cell);

figure()

ss = get(0,'screensize');
vert = 800;
horz = 1200;
set(gcf,'Position',[2000, 1500, horz, vert]);

subplot(1, 2, 1)
doDHRaster(i_cell)
title({"N-Spot";"Spikes Raster"});

subplot(1, 2, 2);
barh([rep_pattern_avgRate, rep_pattern_prediction])
xlabel("Mean Spiking Rate (Hz)");
yticks(1:length(rep_pattern_avgRate));
title({"N-Spot";"Mean Activation"});
legend("cell recordings", "model prediction", "Location", "Southwest");

title_1 = strcat("Cell #", string(i_cell));
title_2 = strcat("Model Accuracy = ",  string(accuracy));
suptitle({title_1; title_2});



