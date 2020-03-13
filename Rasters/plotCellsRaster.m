% raster for several cells, responding to several repetitions of a stim

function plotCellsRaster(spikes, repetitions, n_steps_stim, rate, varargin)

n_cells = numel(spikes);

% Default Parameters
onset_default = 0;
offset_default = 0;
labels_default = [];
dead_times_default = {};
cells_indices_default = 1:n_cells;

line_spacing_default = 3;
size_points_default = 15;
rect_color_default = [.85 .9 .9];
colors_default = getColors(n_cells);
title_default = 'Stim Raster Plot';

% Parse Input
p = inputParser;
addRequired(p, 'spikes');
addRequired(p, 'repetitions');
addRequired(p, 'n_steps_stim');
addRequired(p, 'rate');
addParameter(p, 'Response_Offset_Seconds', offset_default);
addParameter(p, 'Response_Onset_Seconds', onset_default);
addParameter(p, 'Labels', labels_default);
addParameter(p, 'Dead_Times', dead_times_default);
addParameter(p, 'Cells_Indices', cells_indices_default);
addParameter(p, 'Line_Spacing', line_spacing_default);
addParameter(p, 'Point_Size', size_points_default);
addParameter(p, 'Stim_Color', rect_color_default);
addParameter(p, 'Raster_Colors', colors_default);
addParameter(p, 'Title', title_default);
addParameter(p, 'Column_Size', []);

parse(p, spikes, repetitions, n_steps_stim, rate, varargin{:});

onset_seconds = p.Results.Response_Onset_Seconds; 
offset_seconds = p.Results.Response_Offset_Seconds; 
labels = p.Results.Labels; 
dead_times = p.Results.Dead_Times; 
cells_idx = p.Results.Cells_Indices; 
line_spacing = p.Results.Line_Spacing; 
point_size = p.Results.Point_Size; 
stim_color = p.Results.Stim_Color; 
raster_colors = p.Results.Raster_Colors; 
column_size = p.Results.Column_Size; 
title_txt = p.Results.Title; 

if isempty(column_size)
    column_size = numel(cells_idx);
end

offset_resp = offset_seconds*rate;
onset_resp = onset_seconds*rate;
n_steps_resp =  n_steps_stim - onset_resp + offset_seconds;

stim_duration = n_steps_stim / rate;
response_duration = n_steps_resp / rate;

n_repetitions = numel(repetitions);
n_tot_repetitions = column_size * (n_repetitions + line_spacing);

% build figure with background rectangle representing holo stimulation
xlim([min(0, onset_seconds), max(stim_duration, response_duration)])
ylim([-line_spacing, n_tot_repetitions])

hold on
set(gca,'ytick',[])
xlabel("Spike Times (s)")
ylabel("Cells")

% add a stripe o spike trains for each pattern
i_row = 0;
y_ticks = [];

rs_init = repetitions;
rs_end = repetitions + n_steps_resp;

for i_cell = cells_idx
    spikes_cell = spikes{i_cell};
    color = raster_colors(i_cell, :);
    rect_edges = [0, i_row-1, n_steps_stim/rate, n_repetitions+1];
    rectangle('Position', rect_edges, 'FaceColor', stim_color, 'EdgeColor', 'none')
    
    if ~isempty(dead_times)
        for i_dt = 1:numel(dead_times.begin)
            dt_begin = dead_times.begin(i_dt)/rate;
            dt_end = dead_times.end(i_dt)/rate;

            rect_edges = [dt_begin, i_row-1, dt_end - dt_begin, n_repetitions+1];
            rectangle('Position', rect_edges, 'FaceColor', 'k', 'EdgeColor', 'k')
        end
    end

    for r = 1:n_repetitions
        i_row = i_row + 1;
        
        spikes_segment = and(spikes_cell > rs_init(r) + onset_resp, spikes_cell < rs_end(r) + offset_resp);
        spikes_rep = spikes_cell(spikes_segment) - rs_init(r);
        spikes_rep = spikes_rep(:).';
        y_spikes_rep = ones(1, length(spikes_rep)) * i_row;
        scatter(spikes_rep / rate, y_spikes_rep, point_size, color, 'Filled', 'o')
    end  
    y_ticks = [y_ticks, i_row - n_repetitions/2];  
    i_row = i_row + line_spacing;
end
yticks(y_ticks)
yticklabels(cells_idx);
title(title_txt, 'Interpreter', 'None')

% add window
xline(0, 'LineWidth', 1.5, 'Color', 'red');
xline(stim_duration, 'LineWidth', 1.5, 'Color', 'red');

