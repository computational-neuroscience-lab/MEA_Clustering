% raster for one cell, responding to several repetitions of distinct patterns

function plotStimRaster(spikes, repetitions, n_steps_stim, rate, varargin)

n_patterns = numel(repetitions);


% Default Parameters
onset_default = 0;
offset_default = 0;
edges_onset_default = 0;
edges_offset_default = 0;
labels_default = [];
dead_times_default = {};
pattern_indices_default = 1:n_patterns;

line_spacing_default = 3;
size_points_default = 15;
rect_color_default = [.85 .9 .9];
colors_default = getColors(n_patterns);
n_max_reps_default = 0;
title_default = 'Stim Raster Plot';

% Parse Input
p = inputParser;
addRequired(p, 'spikes');
addRequired(p, 'repetitions');
addRequired(p, 'n_steps_stim');
addRequired(p, 'rate');
addParameter(p, 'Response_Offset_Seconds', offset_default);
addParameter(p, 'Response_Onset_Seconds', onset_default);
addParameter(p, 'Edges_Offset_Seconds', edges_offset_default);
addParameter(p, 'Edges_Onset_Seconds', edges_onset_default);
addParameter(p, 'Labels', labels_default);
addParameter(p, 'Dead_Times', dead_times_default);
addParameter(p, 'Pattern_Indices', pattern_indices_default);
addParameter(p, 'Line_Spacing', line_spacing_default);
addParameter(p, 'Point_Size', size_points_default);
addParameter(p, 'Stim_Color', rect_color_default);
addParameter(p, 'Raster_Colors', colors_default);
addParameter(p, 'N_Max_Repetitions', n_max_reps_default);
addParameter(p, 'Title', title_default);
addParameter(p, 'Column_Size', []);

parse(p, spikes, repetitions, n_steps_stim, rate, varargin{:});

onset_seconds = p.Results.Response_Onset_Seconds; 
offset_seconds = p.Results.Response_Offset_Seconds; 
edges_onset_seconds = p.Results.Edges_Onset_Seconds; 
edges_offset_seconds = p.Results.Edges_Offset_Seconds; 
labels = p.Results.Labels; 
dead_times = p.Results.Dead_Times; 
pattern_idx = p.Results.Pattern_Indices; 
line_spacing = p.Results.Line_Spacing; 
point_size = p.Results.Point_Size; 
stim_color = p.Results.Stim_Color; 
raster_colors = p.Results.Raster_Colors; 
n_max_repetitions = p.Results.N_Max_Repetitions; 
column_size = p.Results.Column_Size; 
title_txt = p.Results.Title; 

if isempty(column_size)
    column_size = numel(pattern_idx);
end

offset_resp = offset_seconds*rate;
onset_resp = onset_seconds*rate;
n_steps_resp =  n_steps_stim - onset_resp + offset_seconds;

stim_duration = n_steps_stim / rate;
response_duration = n_steps_resp / rate;

for reps = repetitions
    n_max_repetitions = max(n_max_repetitions, numel(reps{:}));
end
n_tot_repetitions = column_size * (n_max_repetitions + line_spacing);

% build figure with background rectangle representing holo stimulation
xlim([min(0, onset_seconds), max(stim_duration, response_duration)])
ylim([-line_spacing, n_tot_repetitions])

hold on
set(gca,'ytick',[])
xlabel("Spike Times (s)")
% ylabel("Patterns (with spot intensities)")

% add a stripe o spike trains for each pattern
i_row = 0;
y_ticks = [];

for i_pattern = pattern_idx
    rs_init = repetitions{i_pattern};
    rs_end = repetitions{i_pattern} + n_steps_stim;
    color = raster_colors(i_pattern, :);
    
    rect_edges = [0, i_row-1, n_steps_stim/rate, n_max_repetitions+1];
    rectangle('Position', rect_edges, 'FaceColor', stim_color, 'EdgeColor', 'none')
    
    if ~isempty(dead_times)
        for i_dt = 1:numel(dead_times{i_pattern}.begin)
            dt_begin = dead_times{i_pattern}.begin(i_dt)/rate;
            dt_end = dead_times{i_pattern}.end(i_dt)/rate;

            rect_edges = [dt_begin, i_row-1, dt_end - dt_begin, n_max_repetitions+1];
            rectangle('Position', rect_edges, 'FaceColor', 'k', 'EdgeColor', 'k')
        end
    end
    
    for r = 1:n_max_repetitions
        i_row = i_row + 1;
        
        if r <= numel(repetitions{i_pattern})
            spikes_segment = and(spikes > rs_init(r) + onset_resp, spikes < rs_end(r) + offset_resp);
            spikes_rep = spikes(spikes_segment) - rs_init(r);
            spikes_rep = spikes_rep(:).';
            y_spikes_rep = ones(1, length(spikes_rep)) * i_row;
            scatter(spikes_rep / rate, y_spikes_rep, point_size, color, 'Filled', 'o')
        end
    end  
    y_ticks = [y_ticks, i_row - n_max_repetitions/2];  
    i_row = i_row + line_spacing;
end
yticks(y_ticks)
yticklabels(labels);
title(title_txt, 'Interpreter', 'None')

% add window
if ~(isempty(edges_onset_seconds) || isempty(edges_onset_seconds))
    colors_edges = getColors(numel(edges_onset_seconds));
    for i_b = 1:numel(edges_onset_seconds)
        xline(edges_onset_seconds(i_b), 'LineWidth', 1.5, 'Color', colors_edges(i_b, :));
        xline(edges_offset_seconds(i_b), 'LineWidth', 1.5, 'Color', colors_edges(i_b, :));
    end
end

