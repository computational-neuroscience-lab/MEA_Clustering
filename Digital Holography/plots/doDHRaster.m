function doDHRaster(i_cell, pattern_type)

% Load Spikes
load(getDatasetMat(), "spikes");
load(getDatasetMat(), "params");
load(getDatasetMat(), "dh");

r_initial_offset = -0.75;
r_length = dh.period + -r_initial_offset * 2;

spike_train = spikes{i_cell};

% Load Triggers of DH Spots
load(getDatasetMat(), "experiments");
assert(numel(experiments) == 1)
expId =  experiments{1};

dh_path = strcat(dataPath, "/", expId, "/processed/DHSpots/DHSpots_stim.mat");
dead_times_path = strcat(dataPath, "/", expId, "/processed/deadtimes.txt");
load(dh_path, "evtTimes")
load(dead_times_path)

% Get all Stim Repetitions
[r_repeated, ~, ~] = getSpotsRepetitions(evtTimes, pattern_type);
n_patterns = numel(r_repeated);
n_tot_repetitions = 0;
for r = r_repeated
    n_tot_repetitions = n_tot_repetitions + length(r{:});
end

% build figure with background rectangle representing holo stimulation
colors = getColors(n_patterns);

xlim([0, r_length])
ylim([0, n_tot_repetitions])

rect_color = [.6 .9 .9];
rect_edges = [-r_initial_offset, 0, dh.period, n_tot_repetitions];
rectangle('Position', rect_edges,'FaceColor', rect_color)
hold on

% add a stripe o spike trains for each pattern
i_row = 0;
for i_pattern = 1:numel(r_repeated)
    rs_init = r_repeated{i_pattern} + r_initial_offset * params.meaRate;
    rs_end = r_repeated{i_pattern} + (r_initial_offset + r_length) * params.meaRate;
    color = colors(i_pattern, :);

    for r = 1:length(rs_init)
        i_row = i_row + 1;

        spikes_segment = and(spike_train > rs_init(r), spike_train < rs_end(r));
        spikes_rep = (spike_train(spikes_segment) - rs_init(r));
        spikes_rep = spikes_rep(:).';
        
        y_spikes_rep = ones(1, length(spikes_rep)) * i_row;
        
        scatter(spikes_rep / params.meaRate, y_spikes_rep, 6, color, 'filled')
    end        
end

set(gca,'ytick',[])
xlabel("Spike Times (s)")
ylabel("Patterns")
title(strcat("Cell #", string(i_cell), ", ", pattern_type, " patterns"))