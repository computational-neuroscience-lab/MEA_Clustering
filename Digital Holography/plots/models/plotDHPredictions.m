function plotDHPredictions(i_cell, session, model_label)

% Load Spikes
load(getDatasetMat(), 'spikes');
load(getDatasetMat(), 'params');

% Load Triggers of DH Spots
s = load(getDatasetMat(), session);
dh_spot_duration = s.(session).params.period;

% Get all Stim Repetitions
test_begin_time = s.(session).repetitions.test;

figure()
fullScreen()

subplot(1, 2, 2);
plotDHPredictionHistos(i_cell, session, model_label)

subplot(1, 2, 1)
reps_patterns = test_begin_time;
labels = yPatternLabels(s.(session).stimuli.test);
plotStimRaster(spikes{i_cell}, reps_patterns, dh_spot_duration, dh_spot_duration, params.meaRate, labels)
title([char(session) ', Cell #' num2str(i_cell) ': Testing Set Raster'], 'Interpreter', 'None')
