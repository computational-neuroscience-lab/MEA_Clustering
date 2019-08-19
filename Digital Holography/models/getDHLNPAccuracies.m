function [accuracy, prediction, firingRates] = getDHLNPAccuracies(i_cell)

load(getDatasetMat, 'dh_models');
accuracy = dh_models.accuracies;
prediction = dh_models.predictions;
firingRates = dh_models.firingRates;

if exist('i_cell', 'var')
    accuracy = accuracy(i_cell);
    prediction = prediction(i_cell, :);
    firingRates = firingRates(i_cell, :);
end