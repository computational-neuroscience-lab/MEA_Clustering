function plotDHPredictions(i_cell, model_label)

% Load Spikes
load(getDatasetMat(), "spikes");
load(getDatasetMat(), "params");
load(getDatasetMat(), "dh");

% Load Triggers of DH Spots
load(getDatasetMat(), "experiments");
assert(numel(experiments) == 1)
reps_file = [dataPath '/' char(experiments{1}) '/processed/DH/DHRepetitions.mat'];

cell_spikes = spikes{i_cell};

% Get all Stim Repetitions
load(reps_file, "zero_begin_time");
load(reps_file, "single_begin_time");
load(reps_file, "test_begin_time");

figure()

try
    ss = get(0,'MonitorPositions'); % try to get the secondary monitor
    x_0 = ss(2, 1);
    y_0 = ss(2, 2);
    width = ss(2, 3);
    height = ss(2, 4);
    set(gcf,'Position',[x_0, y_0, width, height]);
catch
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    set(gcf,'Position',[0, 0, width, height]);
end

subplot(1, 4, 4);
plotDHHistogram(i_cell, model_label)

subplot(1, 4, 1)
idx_patterns = 1:50;
reps_patterns = single_begin_time(idx_patterns);
labels = yPatternLabels(dh.stimuli.singles(idx_patterns, :));
plotStimRaster(cell_spikes, reps_patterns, 0.5, 0.5, 20000, labels)
title(strcat("Cell #", string(i_cell), ": 1-Spots Raster"))

subplot(1, 4, 2)
idx_patterns = 51:100;
reps_patterns = single_begin_time(idx_patterns);
labels = yPatternLabels(dh.stimuli.singles(idx_patterns, :));
plotStimRaster(cell_spikes, reps_patterns, 0.5, 0.5, 20000, labels)
title(strcat("Cell #", string(i_cell), ": 1-Spots Raster"))

subplot(1, 4, 3)
reps_patterns = test_begin_time;
labels = yPatternLabels(dh.stimuli.test);
plotStimRaster(cell_spikes, reps_patterns, 0.5, 0.5, 20000, labels)
title(strcat("Cell #", string(i_cell), ": N-Spots Raster"))

