clear

% parameters
expId = '20170614';
spot_attenuation_func = @getDHFrameNormIntensities;

% Load Data
dh_path = strcat(dataPath, '/', expId, "/processed/DH/DHTimes.mat");
load(getDatasetMat(), "spikes");
load(getDatasetMat(), "params");
load(dh_path, "dhTimes")
n_cells = numel(spikes);


% PSTH parameters
dh.t_bin = 0.01; % s
dh.period = 0.5; % s
dh.offset_baseline = 0.25; % s
dh.bin_init = 1;
dh.bin_end = 50;

n_bins = floor(dh.period / dh.t_bin);
n_bins_baseline = floor(dh.offset_baseline / dh.t_bin);

bin_size = dh.t_bin * params.meaRate;

% Iterate over the different types of stimulatione sequences

repetitionsFile = [dataPath() '/' expId '/processed/DH/DHRepetitions.mat'];

patterns_types = ["unique", "repeated", "singles"];
patterns_begin_time = ["unique_begin_time", "multi_begin_time", "single_begin_time"];
patterns_frames = ["unique_frames", "multi_frames", "single_frames"];

for i_patt = 1:numel(patterns_types)
    
    pattern_type = patterns_types(i_patt);
    repetitions = load(repetitionsFile, patterns_begin_time(i_patt));
    repetitions = repetitions.(patterns_begin_time(i_patt));
    
    rep_frames = load(repetitionsFile, patterns_frames(i_patt));
    rep_frames = rep_frames.(patterns_frames(i_patt));

    % Get Repetitions
    n_patterns = numel(repetitions);
    
    % Compute input intensities
    dh.stimuli.(pattern_type) = spot_attenuation_func(expId, rep_frames);

    % Compute all the responses for each pattern
    dh.responses.(pattern_type).psth = zeros(n_cells, n_patterns, n_bins);
    dh.responses.(pattern_type).responses = cell(n_cells, n_patterns);
    dh.responses.(pattern_type).baseline = zeros(n_cells, n_patterns);
    dh.responses.(pattern_type).baseline_responses = cell(n_cells, n_patterns);
    
    for i_p = 1:n_patterns
        % Responses to DH stim
        r_times = repetitions{i_p};
        [psth, ~, ~, responses] = doPSTH(spikes, r_times, bin_size, n_bins, params.meaRate, 1:n_cells);
        
        dh.responses.(pattern_type).psth(:, i_p, :)   = psth;
        dh.responses.(pattern_type).responses(:, i_p) = num2cell(responses, [2,3]);
        
        % Responses right before the stimulus (as a baseline)
        r_times_baseline = repetitions{i_p}  - dh.offset_baseline * params.meaRate;
        [~, ~, baseline, baseline_responses] = doPSTH(spikes, r_times_baseline, bin_size, n_bins_baseline, params.meaRate, 1:n_cells);
                
        dh.responses.(pattern_type).baseline(:, i_p)   = baseline;
        dh.responses.(pattern_type).baseline_responses(:, i_p) = num2cell(baseline_responses, [2,3]);
    end
end

save(getDatasetMat, "dh", "-append")