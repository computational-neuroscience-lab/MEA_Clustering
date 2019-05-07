closclear
close all

load(getDatasetMat, "dh_stats")

load(getDatasetMat, "dh")
load(getDatasetMat, "cellsTable")
load(getDatasetMat, "classesTable")

n_cells = numel(cellsTable);
n_classes = numel(classesTable);

% Compute mean firing rate
dh_stats.avg_rate_repeated = mean(dh.responses.repeated.psth, 3);
dh_stats.avg_rate_singles = mean(dh.responses.singles.psth, 3);

% Compute repetition synchrony
dh_stats.quality_repeated = cellfun(@spikeTrainsSynchrony, dh.responses.repeated.responses);
dh_stats.quality_singles = cellfun(@spikeTrainsSynchrony, dh.responses.singles.responses);

% Compute adaptation
base_rate_singles = mean(dh.responses.singles.baseline, 2);
base_rate_repeated = mean(dh.responses.repeated.baseline, 2);
dh_stats.adaptation_abs = abs(base_rate_singles - base_rate_repeated);
dh_stats.adaptation_rel = dh_stats.adaptation_abs ./ max(base_rate_singles, base_rate_repeated);

% Compute patterns activation
activation_abs = sum(dh_stats.quality_singles .* dh_stats.avg_rate_singles, 2) ./ sum(dh_stats.quality_singles, 2);
dh_stats.activation = activation_abs ./ max(activation_abs(:));

% Load accuracies
load('_data/accuracies/accuracies.mat', "full")
dh_stats.accuracies = full;

% save
save(getDatasetMat, "dh_stats", "-append");
