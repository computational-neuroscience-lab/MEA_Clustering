clear

% parameters
exp_id = '20170614';

% Load accuracies
MODEL_MATRIX = [dataPath '/' exp_id '/processed/DH/lnp/performances_lnplus.mat'];
load(MODEL_MATRIX, "cells", "accuracy", "mse", "ws", "b", "c")
load(MODEL_MATRIX, 'predictions', 'truths')
load(getDatasetMat, 'cellsTable');

n_cells = numel(cellsTable);
n_weights = size(ws, 2);
n_patterns = size(predictions, 2);

dh_models_plus.isModeled = boolean(zeros(n_cells, 1));
dh_models_plus.isModeled(cells) = true;


dh_models_plus.ws = zeros(n_cells, n_weights);
for n = 1:length(cells)
    i = cells(n);
    dh_models_plus.ws(i, :) = squeeze(ws(n, :));
end

dh_models_plus.b = zeros(n_cells, 1);
dh_models_plus.b(cells) = b;

dh_models_plus.c = zeros(n_cells, 1);
dh_models_plus.c(cells) = c;

dh_models_plus.accuracies = zeros(n_cells, 1);
dh_models_plus.accuracies(cells) = accuracy;

dh_models_plus.mses = zeros(n_cells, 1);
dh_models_plus.mses(cells) = mse;

dh_models_plus.predictions = zeros(n_cells, n_patterns);
dh_models_plus.firingRates = zeros(n_cells, n_patterns);
for n = 1:length(cells)
    i = cells(n);
    dh_models_plus.predictions(i, :) = predictions(n, :);
    dh_models_plus.firingRates(i, :) = truths(n, :);
end

% save
save(getDatasetMat, "dh_models_plus", "-append");
