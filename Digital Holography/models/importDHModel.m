% function importDHModel(model_label, session_label)

model_label = 'LNP';
session_label = 'DHMulti';

load(getDatasetMat(), 'experiments')
if numel(experiments) > 1
    error('you cannot generate DH data for a dataset with multiple manips')
end
exp_id = char(experiments{1});

% Load accuracies
MODEL_MATRIX = [dataPath '/' exp_id '/processed/DH/models/' session_label '/' model_label '.mat'];
load(MODEL_MATRIX, "cells", "accuracy", "mse", "ws", "b")
load(MODEL_MATRIX, 'predictions', 'truths')
load(getDatasetMat, 'cellsTable');


dh_session_struct = load(getDatasetMat, session_label);

n_cells = numel(cellsTable);
n_weights = size(ws, 2);
n_patterns = size(predictions, 2);

dh_session_struct.(session_label).(model_label).isModeled = boolean(zeros(n_cells, 1));
dh_session_struct.(session_label).(model_label).isModeled(cells) = true;


dh_session_struct.(session_label).(model_label).ws = zeros(n_cells, n_weights);
for n = 1:length(cells)
    i = cells(n);
    dh_session_struct.(session_label).(model_label).ws(i, :) = squeeze(ws(n, :));
end

dh_session_struct.(session_label).(model_label).b = zeros(n_cells, 1);
dh_session_struct.(session_label).(model_label).b(cells) = b;

dh_session_struct.(session_label).(model_label).accuracies = zeros(n_cells, 1);
dh_session_struct.(session_label).(model_label).accuracies(cells) = accuracy;

dh_session_struct.(session_label).(model_label).mses = zeros(n_cells, 1);
dh_session_struct.(session_label).(model_label).mses(cells) = mse;

dh_session_struct.(session_label).(model_label).predictions = zeros(n_cells, n_patterns);
dh_session_struct.(session_label).(model_label).firingRates = zeros(n_cells, n_patterns);
for n = 1:length(cells)
    i = cells(n);
    dh_session_struct.(session_label).(model_label).predictions(i, :) = predictions(n, :);
    dh_session_struct.(session_label).(model_label).firingRates(i, :) = truths(n, :);
end

% save
save(getDatasetMat, '-struct', 'dh_session_struct', "-append")
