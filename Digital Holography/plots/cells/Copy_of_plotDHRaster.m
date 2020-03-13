function plotDHRaster(i_cell, session_label, pattern_type, varargin)

onset = -0.5;
offset = 0.5;

% Get all Stim Repetitions
load(getDatasetMat(), 'spikes');
load(getDatasetMat(), 'params');
s = load(getDatasetMat(), session_label);
pattern_reps = s.(session_label).repetitions.(pattern_type);

n_steps_stim = s.(session_label).params.stim_dt * params.meaRate;

% Default Parameters
dead_times_default = false;
patterns_by_column_default = 50;
pattern_indices_default = 1:numel(pattern_reps);
is_subfigure_default = false;

% Parse Input
p = inputParser;
addRequired(p, 'i_cell');
addRequired(p, 'session_label');
addRequired(p, 'pattern_type');

addParameter(p, 'Patterns_Idx', pattern_indices_default);
addParameter(p, 'Dead_Times', dead_times_default);

addParameter(p, 'Column_Size', patterns_by_column_default);

addParameter(p, 'Is_Subfigure', is_subfigure_default);
addParameter(p, 'Columns_Indices', []);
addParameter(p, 'N_Columns', []);

parse(p, i_cell, session_label, pattern_type, varargin{:});
pattern_idx = p.Results.Patterns_Idx; 
n_patterns_by_column = p.Results.Column_Size; 
do_dead_times = p.Results.Dead_Times;

is_sub_figure = p.Results.Is_Subfigure;
columns_idx = p.Results.Columns_Indices;
n_columns = p.Results.N_Columns;


% Unroll all the options about plot structure
if islogical(pattern_idx)
    pattern_idx = find(pattern_idx);
end
n_patterns = length(pattern_idx);

if isempty(n_columns) && isempty(columns_idx)
    n_columns = ceil(n_patterns/n_patterns_by_column);
    columns_idx = 1:n_columns;
    
    if n_columns == 1
        n_patterns_by_column = n_patterns;
    end
    
elseif  ~isempty(n_columns) && isempty(columns_idx)
    columns_idx = 1:n_columns;
    n_patterns_by_column = ceil(n_patterns/length(columns_idx));
    
elseif  isempty(n_columns) && ~isempty(columns_idx)
    n_columns = max(columns_idx);
    n_patterns_by_column = ceil(n_patterns/length(columns_idx));
    
else
    n_patterns_by_column = ceil(n_patterns/length(columns_idx));
end

% If this is an independent figure, initialize the windonw
if ~is_sub_figure
    figure()
    fullScreen()
end

for i_plot = 1:numel(columns_idx)
    
    subplot(1, n_columns, columns_idx(i_plot));
    
    p1 = (i_plot - 1)*n_patterns_by_column + 1;
    p2 = min(n_patterns, i_plot*n_patterns_by_column);
    idx = pattern_idx(p1:p2);

    labels = yPatternLabels(s.(session_label).stimuli.(pattern_type)(idx, :));
    title_txt = [session_label ', Cell #' num2str(i_cell) ': ' char(pattern_type ) ' set, patterns ' num2str(p1) ':' num2str(p2)];
    
    if do_dead_times
        dt_session = s.(session_label).params.reps_label;
        dead_times = getPatternDeadTimes(getExpId(), dt_session, pattern_type, idx);
    else
        dead_times = [];
    end
    
    
    plotStimRaster(spikes{i_cell}, pattern_reps, n_steps_stim, params.meaRate, ...
        'Labels', labels, ...
        'N_Steps', n_steps_stim, ...
        'Response_Onset_Seconds', onset, ...
        'Response_Offset_Seconds', offset, ...
        'Pattern_Indices', idx, ...
        'Dead_Times', dead_times, ...
        'Title', title_txt, ...
        'Column_Size', n_patterns_by_column);
end