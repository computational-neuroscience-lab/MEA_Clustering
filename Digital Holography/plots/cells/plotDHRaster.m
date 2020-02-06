function plotDHRaster(i_cell, session, dataset)

n_patterns_by_column = 50;

% Load Spikes
load(getDatasetMat(), 'spikes');
load(getDatasetMat(), 'params');

% Load Triggers of DH Spots
s = load(getDatasetMat(), session);
dh_spot_duration = s.(session).params.period;

% Get all Stim Repetitions
pattern_reps = s.(session).repetitions.(dataset);
n_patterns = numel(pattern_reps);
n_columns = ceil(n_patterns/n_patterns_by_column);

figure()
fullScreen()

for i_column = 1:n_columns
    subplot(1, n_columns, i_column);
    
    p1 = (i_column - 1)*n_patterns_by_column + 1;
    p2 = min(n_patterns, i_column*n_patterns_by_column);
    idx = p1:p2;

    labels = yPatternLabels(s.(session).stimuli.(dataset)(idx, :));
    plotStimRaster(spikes{i_cell}, pattern_reps(idx), dh_spot_duration, dh_spot_duration, params.meaRate, labels)
    title([session ', Cell #' num2str(i_cell) ': ' char(dataset ) ' set, patterns ' num2str(p1) ':' num2str(p2)], 'Interpreter', 'None')
end