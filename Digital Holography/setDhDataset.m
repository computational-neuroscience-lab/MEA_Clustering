clear

% dataset parameters
session_label = 'DHMulti';      % label of the dataset that will be generated
reps_labels = 'DHMulti';    % label of the session from which to get the repetitions
spot_attenuation_func = @getDHFrameIntensities;
datasets = {'zero', 'single', 'multi', 'test', 'all'};
% expId = '20200131_dh';

% PSTH parameters
trigger_suffix = '_begin_time';  % '_begin_time' or '_end_time'
dh_dataset.params.t_bin = 0.5; % s
dh_dataset.params.period = 0.5; % s
dh_dataset.params.bin_init = 1;
dh_dataset.params.bin_end = 1;

% Load Data
load(getDatasetMat(), 'experiments')
load(getDatasetMat(), 'spikes');
load(getDatasetMat(), 'params');
if numel(experiments) > 1
    error('you cannot analyze DH data for a dataset with multiple manips')
end
expId = char(experiments{1});
n_cells = numel(spikes);
n_bins = floor(dh_dataset.params.period / dh_dataset.params.t_bin);
bin_size = dh_dataset.params.t_bin * params.meaRate;

repetitionsFile = [dataPath() '/' expId '/processed/DH/DHRepetitions' reps_labels '.mat'];
load(repetitionsFile, 'dh_sessions');

coordsFile = [dataPath() '/' expId '/processed/DH/DHCoords' reps_labels '.mat'];
load(coordsFile, 'PatternCoords_MEA');
load(coordsFile, 'PatternCoords_Laser');
load(coordsFile, 'PatternCoords_Img');

% save spots
dh_dataset.spots.coords_mea =  PatternCoords_MEA;
dh_dataset.spots.coords_laser =  PatternCoords_Laser;
dh_dataset.spots.coords_img =  PatternCoords_Img;
dh_dataset.sessions = dh_sessions;
data.(session_label) = dh_dataset;
save(getDatasetMat, '-struct', 'data', "-append")

% save repetitions
for i_data = 1:numel(datasets)
    
    dataset_label = datasets{i_data};
    frames_label = [dataset_label '_frames'];
    trigger_label = [dataset_label trigger_suffix];

    r = load(repetitionsFile, trigger_label);
    repetitions = r.(trigger_label);
    
    s = load(repetitionsFile, frames_label);
    rep_frames = s.(frames_label);

    % Get Repetitions
    n_patterns = numel(repetitions);
    
    % Compute input intensities
    dh_dataset.stimuli.(dataset_label) = spot_attenuation_func(session_label, rep_frames);
    dh_dataset.repetitions.(dataset_label) = repetitions';

    % Compute all the responses for each pattern
    dh_dataset.responses.(dataset_label).firingRates = zeros(n_cells, n_patterns);
    dh_dataset.responses.(dataset_label).spikeCounts = cell(n_cells, n_patterns);
    
    for i_p = 1:n_patterns
        % Responses to DH stim
        r_times = repetitions{i_p};

        if ~isempty(r_times)
            [psth, ~, ~, responses] = doPSTH(spikes, r_times, bin_size, n_bins, params.meaRate, 1:n_cells);
            dh_dataset.responses.(dataset_label).firingRates(:, i_p) = psth;
            for i_cell = 1:n_cells
                dh_dataset.responses.(dataset_label).spikeCounts(i_cell, i_p) = {responses(i_cell, :)};
            end
        end
    end
end

% computeDHActivation(session_label)



dh_dataset.sessions = dh_sessions;
data.(session_label) = dh_dataset;
save(getDatasetMat, '-struct', 'data', "-append")