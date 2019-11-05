function [accuracy, prediction, firingRates] = getDHLNPAccuracies(i_cell, model)

load(getDatasetMat, 'dh_models');
accuracy = dh_models.(model).accuracies;
prediction = dh_models.(model).predictions;
firingRates = dh_models.(model).firingRates;

if exist('i_cell', 'var')
    accuracy = accuracy(i_cell);
    prediction = prediction(i_cell, :);
    firingRates = firingRates(i_cell, :);
end