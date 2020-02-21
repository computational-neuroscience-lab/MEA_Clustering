function plotDHRasterSingleAndTest(i_cell, session)

% Load Spikes
load(getDatasetMat(), 'spikes');
load(getDatasetMat(), 'params');

% Load Triggers of DH Spots
s = load(getDatasetMat());
dh_spot_duration = s.(session).params.period;

figure()
fullScreen()


subplot(1, 3, 1);
labels_single = yPatternLabels(s.DHSingle.stimuli.single);
plotStimRaster(spikes{i_cell}, s.DHSingle.repetitions.single, dh_spot_duration, dh_spot_duration, params.meaRate, labels_single)
title(['DHSingle' ', Cell #' num2str(i_cell) ': single set'], 'Interpreter', 'None')

subplot(1, 3, 2);
labels_single = yPatternLabels(s.(session).stimuli.single);
plotStimRaster(spikes{i_cell}, s.(session).repetitions.single, dh_spot_duration, dh_spot_duration, params.meaRate, labels_single)
title([session ', Cell #' num2str(i_cell) ': single set'], 'Interpreter', 'None')

subplot(1, 3, 3);
labels_test = yPatternLabels(s.(session).stimuli.test);
plotStimRaster(spikes{i_cell}, s.(session).repetitions.test, dh_spot_duration, dh_spot_duration, params.meaRate, labels_test)
title([session ', Cell #' num2str(i_cell) ': test set, patterns'], 'Interpreter', 'None')