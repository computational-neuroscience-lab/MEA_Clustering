function loadDHModel(exp_id, model_label)

load(getDatasetMat, "dh_models");

% Load accuracies
MODEL_MATRIX = [dataPath '/' exp_id '/processed/DH/models/performances_' model_label '.mat'];
load(MODEL_MATRIX, "cells", "accuracy", "mse", "ws", "b", "tr_len", "spots")
load(MODEL_MATRIX, 'predictions', 'truths')
load(getDatasetMat, 'cellsTable');

n_cells = numel(cellsTable);
n_weights = size(ws, 2);
n_patterns = size(predictions, 2);

% dh_models.(model_label).isModeled = boolean(zeros(n_cells, 1));
% dh_models.(model_label).isModeled(cells) = true;
% 
% 
% dh_models.(model_label).ws = zeros(n_cells, n_weights);
% for n = 1:length(cells)
%     i = cells(n);
%     dh_models.(model_label).ws(i, :) = squeeze(ws(n, :));
% end
% 
% dh_models.(model_label).b = zeros(n_cells, 1);
% dh_models.(model_label).b(cells) = b;
% 
% dh_models.(model_label).accuracies = zeros(n_cells, 1);
% dh_models.(model_label).accuracies(cells) = accuracy;
% 
% dh_models.(model_label).mses = zeros(n_cells, 1);
% dh_models.(model_label).mses(cells) = mse;
% 
% dh_models.(model_label).predictions = zeros(n_cells, n_patterns);
% dh_models.(model_label).firingRates = zeros(n_cells, n_patterns);
% for n = 1:length(cells)
%     i = cells(n);
%     dh_models.(model_label).predictions(i, :) = predictions(n, :);
%     dh_models.(model_label).firingRates(i, :) = truths(n, :);
% end

dh_models.(model_label).tr_len = tr_len;
dh_models.(model_label).n_spots = spots;

% save
save(getDatasetMat, "dh_models", "-append");
