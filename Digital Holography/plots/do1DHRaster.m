function do1DHRaster(i_cell, idx_patterns)

% Load Spikes
load(getDatasetMat(), "spikes");
load(getDatasetMat(), "params");
load(getDatasetMat(), "dh");

r_initial_offset = -0.5;
r_length = dh.period + -r_initial_offset * 2;

w_init = dh.t_bin * (dh.bin_init-1) - r_initial_offset;
w_end = dh.t_bin * (dh.bin_end) - r_initial_offset;

spike_train = spikes{i_cell};

% Load Triggers of DH Spots
load(getDatasetMat(), "experiments");
assert(numel(experiments) == 1)
expId =  experiments{1};

reps_file = [dataPath '/' char(expId) '/processed/DH/DHRepetitions.mat'];

% Get all Stim Repetitions
load(reps_file, "single_begin_time");

if ~exist('idx_patterns', 'var')
    idx_patterns = 1:numel(single_begin_time);
end

rep_begin_time = single_begin_time(idx_patterns);
n_patterns = numel(rep_begin_time);

n_tot_repetitions = 0;
for r = rep_begin_time
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

set(gca,'ytick',[])
xlabel("Spike Times (s)")
ylabel("Patterns")
title(strcat("Cell #", string(i_cell), ": 1-Spots Raster"))

% add a stripe o spike trains for each pattern
i_row = 0;
y_ticks = zeros(1, numel(rep_begin_time));

for i_pattern = 1:numel(rep_begin_time)
    rs_init = rep_begin_time{i_pattern} + r_initial_offset * params.meaRate;
    rs_end = rep_begin_time{i_pattern} + (r_initial_offset + r_length) * params.meaRate;
    color = colors(i_pattern, :);

    for r = 1:length(rs_init)
        i_row = i_row + 1;

        spikes_segment = and(spike_train > rs_init(r), spike_train < rs_end(r));
        spikes_rep = (spike_train(spikes_segment) - rs_init(r));
        spikes_rep = spikes_rep(:).';
        
        y_spikes_rep = ones(1, length(spikes_rep)) * i_row;
        
        scatter(spikes_rep / params.meaRate, y_spikes_rep, 20, color, 'filled')
    end  
    y_ticks(i_pattern) = i_row;  
end
yticks(y_ticks)
yticklabels(yPatternLabels(dh.stimuli.singles(idx_patterns, :)));

% add window
line([w_init w_init], [0 i_row], 'LineWidth', 1.5, 'Color', 'red'); 
line([w_end w_end], [0 i_row], 'LineWidth', 1.5, 'Color', 'red'); 

