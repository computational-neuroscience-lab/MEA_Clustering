function setDatasetOnlyCheckerboard(dataset_name, experiments, accepted_labels, mea_rate, psth_tBin)
% DATASETNAME = "170614_ABC_25jan";
% it is the identifier for the given dataset.
 
% EXPERIMENTS = {"name_file_exp1", "name_file_exp2", etc...}; 
% files must be inside the dataPath() folder.
% dataset is created with the data from selected experiments

% ACCEPTEDLABELS = 3; 
% cells are accepted only with sorting score >= to [acceptedlabels]
% 5=A, 4=AB, 3=ABC

% Experimental parameters
params.meaRate = mea_rate; %Hz
params.psth.tBin = psth_tBin; % s
    
% Initialization
indices_list = {};
features_list = {};
spikes = {};
temporalSTAs = [];
spatialSTAs = [];
stas = [];
psths = [];

for i_exp = 1:numel(experiments)
    exp_id = char(experiments{i_exp});
    disp(['Experiment ' exp_id])

    %----- PATHS ---------------------------%

    spikes_mat = [dataPath() '/' exp_id, '/processed/SpikeTimes.mat'];
    tags_mat = [dataPath() '/' exp_id, '/processed/Tags.mat'];

    repetitions_mat = [dataPath() '/' exp_id, '/processed/CheckerBoard/Checkerboard_RepetitionTimes.mat'];
    sta_mat = [dataPath() '/' exp_id, '/processed/STA/Sta.mat'];

    %----- LOADs -------------------------------%

    load(repetitions_mat, "rep_begin", "rep_end")
    load(spikes_mat, "SpikeTimes")
    load(sta_mat, "STAs")

    try
        load(tags_mat, "Tags")
    catch
        disp("WARNING: TAGGES NOT FOUND. RATING ALL CELLS AS [A]")
        Tags = ones(numel(SpikeTimes), 1) * 5;
    end

    
    %----- PSTH & STA ---------------------------------------%
    
    disp('  PSTH')
    % modeling parameters
    n_steps = rep_end(1) - rep_begin(1) + 1*params.meaRate;
    bin_size = params.psth.tBin * params.meaRate;
    n_tBins = round(n_steps / bin_size);
    
    [psth_chunk, ~, ~] = doPSTH(SpikeTimes, rep_begin, bin_size, n_tBins, params.meaRate, 1:numel(SpikeTimes));
    
    disp('  STA')
    [temporal_sta, spatial_sta, rfs, indices_sta] = decomposeSTA(STAs);
    rf_areas = getRFArea(rfs);
    
    %----- VALIDATION ---------------------------%
    
    disp('  VALIDATION')
    indices_tags = find(Tags>=accepted_labels).';
    indices_psth = getValidIndicesPSTH(psth_chunk);
    
    bad_stas = numel(SpikeTimes) - numel(indices_sta);
    bad_psths = numel(SpikeTimes) - numel(indices_psth);
    
    if bad_stas > 0 
        fprintf('\t%i/%i cells excluded for bad STA\n', bad_stas, numel(SpikeTimes))
    end
    if bad_psths > 0 
        fprintf('\t%i/%i cells excluded for bad PSTH\n', bad_psths, numel(SpikeTimes))
    end
    fprintf('\n')
    
    good_cells = intersect(indices_tags, intersect(indices_psth, indices_sta));
    indices_list{i_exp} = good_cells;
    
    
    %----- FEATURES ---------------------------%
         
    features_list{i_exp} = generateStandardFeatureVec(psth_chunk(good_cells, :), temporal_sta(good_cells, :), rf_areas(good_cells));
    temporalSTAs = [temporalSTAs; normalizeTemporalSTA(temporal_sta(good_cells, :))];
    spatialSTAs = [spatialSTAs, rfs(good_cells)];
    stas = [stas, STAs(good_cells)];
    psths = [psths;  psth_chunk(good_cells, :)];
    spikes = [spikes, SpikeTimes(good_cells)];
    
    disp('')
end

createEmptyDataset(dataset_name)
[cellsTable, tracesMat] = buildDatasetTable(experiments, indices_list, features_list);
save(getDatasetMat, 'cellsTable', 'tracesMat');
save(getDatasetMat(), 'experiments', 'spikes', 'temporalSTAs', 'spatialSTAs', 'stas', 'psths', 'params', '-append')