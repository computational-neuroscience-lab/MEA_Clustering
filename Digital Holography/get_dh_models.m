clear

% parameters
exp_id = '20170614';

% Load accuracies
MODEL_MATRIX = [dataPath '/' exp_id '/processed/DH/lnp/performances.mat'];
load(MODEL_MATRIX, "cells", "accuracy", "mse", "ws", "b")
load(MODEL_MATRIX, 'predictions', 'truths')
load(getDatasetMat, 'cellsTable');

n_cells = numel(cellsTable);
n_weights = size(ws, 2);
n_patterns = size(predictions, 2);

dh_models.isModeled = boolean(zeros(n_cells, 1));
dh_models.isModeled(cells) = true;


dh_models.ws = zeros(n_cells, n_weights);
for n = 1:length(cells)
    i = cells(n);
    dh_models.ws(i, :) = squeeze(ws(n, :));
end

dh_models.b = zeros(n_cells, 1);
dh_models.b(cells) = b;

dh_models.accuracies = zeros(n_cells, 1);
dh_models.accuracies(cells) = accuracy;

dh_models.mses = zeros(n_cells, 1);
dh_models.mses(cells) = mse;

dh_models.predictions = zeros(n_cells, n_patterns);
dh_models.firingRates = zeros(n_cells, n_patterns);
for n = 1:length(cells)
    i = cells(n);
    dh_models.predictions(i, :) = predictions(n, :);
    dh_models.firingRates(i, :) = truths(n, :);
end

% save
save(getDatasetMat, "dh_models", "-append");
