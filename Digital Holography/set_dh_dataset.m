clear

% experimental parameters
meaRate = 20000; %Hz
psth_tBin = 0.05; % s
    
% other parameters
datasetName = "dh_2";
expId = "20170614";
acceptedLabels = 3; % 5=A, 4=AB, 3=ABC

% create the dataset
% setDataset(datasetName, {expId}, acceptedLabels, meaRate, psth_tBin);
% treeClassification();

% Load Data
dh_path = strcat(dataPath, '/', expId, "/processed/DHSpots/DHSpots_stim.mat");
load(getDatasetMat(), "spikes");
load(getDatasetMat(), "params");
load(dh_path, "evtTimes")
n_cells = numel(spikes);


% PSTH parameters
dh.t_res = 0.1; % s
dh.t_bin = 0.1; % s
dh.period = 0.5; % s
dh.offset_baseline = 0.5; % s

n_bins = floor(dh.period / dh.t_bin);
n_bins_baseline = floor(dh.offset_baseline / dh.t_bin);

bin_size = dh.t_bin * params.meaRate;

% Iterate over the different types of stimulatione sequences
patterns_types = ["unique", "repeated", "singles"];
for pattern_type = patterns_types
    
    % Get Repetitions
    [repetitions, ~, patterns_ids] = getSpotsRepetitions(evtTimes, pattern_type);
    n_patterns = numel(repetitions);
    
    % Compute input intensities
    dh.stimuli.(pattern_type) = getDHFrameIntensities(patterns_ids);

    % Compute all the responses for each pattern
    dh.responses.(pattern_type).psth = zeros(n_cells, n_patterns, n_bins);
    dh.responses.(pattern_type).responses = cell(n_cells, n_patterns);
    dh.responses.(pattern_type).baseline = zeros(n_cells, n_patterns);
    dh.responses.(pattern_type).baseline_responses = cell(n_cells, n_patterns);
    
    for i_p = 1:n_patterns
        % Responses to DH stim
        r_times = repetitions{i_p};
        [psth, ~, ~, responses] = doSmoothPSTH(spikes, r_times, bin_size, n_bins, params.meaRate, 1:n_cells, dh.t_res);
        
        dh.responses.(pattern_type).psth(:, i_p, :)   = psth;
        dh.responses.(pattern_type).responses(:, i_p) = num2cell(responses, [2,3]);
        
        % Responses right before the stimulus (as a baseline)
        r_times_baseline = repetitions{i_p}  - dh.offset_baseline * params.meaRate;
        [~, ~, baseline, baseline_responses] = doSmoothPSTH(spikes, r_times_baseline, bin_size, n_bins_baseline, params.meaRate, 1:n_cells, dh.t_res);
                
        dh.responses.(pattern_type).baseline(:, i_p)   = baseline;
        dh.responses.(pattern_type).baseline_responses(:, i_p) = num2cell(baseline_responses, [2,3]);
    end
end


% Create another dataset by splitting single patterns in train & test sets
dh.responses.singles_train.psth = zeros(n_cells, n_patterns, n_bins);
dh.responses.singles_train.responses = cell(n_cells, n_patterns);

dh.responses.singles_test.psth = zeros(n_cells, n_patterns, n_bins);
dh.responses.singles_test.responses = cell(n_cells, n_patterns);

for i_p = 1:n_patterns
% Split the singles dataset: 80% of repetitions for train & 20% for test
    r_times = repetitions{i_p};
    n_reps = length(r_times);
    
    % shuffle the repetitions
    all_random_reps = randperm(n_reps);
    
    % 1/5 of repetitions go into testing set
    % the remaining goes into training set
    edge = round(n_reps / 5);
    r_times_test = r_times(all_random_reps(1:edge));
    r_times_train = r_times(all_random_reps(edge+1: end));
    
    % Responses to DH stim
    [psth_test, ~, m_psth_test, responses_test] = doSmoothPSTH(spikes, r_times_test, bin_size, n_bins, params.meaRate, 1:n_cells, dh.t_res);
    [psth_train, ~, m_psth_train, responses_train] = doSmoothPSTH(spikes, r_times_train, bin_size, n_bins, params.meaRate, 1:n_cells, dh.t_res);

    dh.responses.singles_test.psth(:, i_p, :)   = psth_test;
    dh.responses.singles_test.responses(:, i_p) = num2cell(responses_test, [2,3]);

    dh.responses.singles_train.psth(:, i_p, :)   = psth_train;
    dh.responses.singles_train.responses(:, i_p) = num2cell(responses_train, [2,3]);
end

save(getDatasetMat, "dh", "-append")