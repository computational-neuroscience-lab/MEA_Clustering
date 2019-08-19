function doDHHistogram(i_cell)

% Load PSTHS
load(getDatasetMat(), "dh", "dh_models", "cellsTable");

prediction = dh_models.predictions(i_cell, :)';
firingRates = dh_models.firingRates(i_cell, :)';
barh([firingRates, prediction])
xlabel("Mean Spiking Rate (Hz)");

yticks(1:size(dh.stimuli.repeated, 1));
yticklabels(yPatternLabels(dh.stimuli.repeated));

title( strcat("Cell #", string(i_cell), ": multi spot mean activation"));
legend("cell recordings", "model prediction");
accuracy = dh_models.accuracies(i_cell);
