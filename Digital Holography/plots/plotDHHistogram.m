function plotDHHistogram(i_cell, model_label)

% Load PSTHS
load(getDatasetMat(), "dh", "dh_models", "cellsTable");

prediction = dh_models.(model_label).predictions(i_cell, :)';
firingRates = dh_models.(model_label).firingRates(i_cell, :)';
barh([firingRates, prediction], 'FaceColor','flat', 'EdgeColor', 'none')
xlabel("Mean Spiking Rate (Hz)");

yticks(1:size(dh.stimuli.test, 1));
yticklabels(yPatternLabels(dh.stimuli.test));

title( strcat("Cell #", string(i_cell), ": multi spot mean activation"));
% legend("cell recordings", "model prediction");
accuracy = dh_models.(model_label).accuracies(i_cell);
