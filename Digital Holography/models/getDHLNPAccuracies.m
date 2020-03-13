function [accuracy, rmses, prediction, firingRates] = getDHLNPAccuracies(session_label, model, i_cell)

dh_session_struct = load(getDatasetMat, session_label);

accuracy = dh_session_struct.(session_label).(model).accuracies;
rmses = dh_session_struct.(session_label).(model).rmses;
prediction = dh_session_struct.(session_label).(model).predictions;
firingRates = dh_session_struct.(session_label).(model).firingRates;

if exist('i_cell', 'var')
    accuracy = accuracy(i_cell);
    rmses = rmses(i_cell);
    prediction = prediction(i_cell, :);
    firingRates = firingRates(i_cell, :);
end