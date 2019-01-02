clear

% Parameters
datasetName = "6MEA_AB_22nov";
exp_path = "/media/fran_tr/Elements/MEA_Experiments/";
experiments = {"20170614", "20180705", "20180209", "20181017", "20181018a", "20181018b"};
acceptedLabels = 4; % 5=A, 4=AB, 3=ABC

% Initialization
indices_list = {};
features_list = {};
temporalSTAs = [];
spatialSTAs = [];
stas = [];
psths = [];

for iExp = 1:numel(experiments)
    expId = experiments{iExp};
    disp(strcat("Experiment #", string(iExp)))

    
    %----- PATHS ---------------------------%

    spikesMat = strcat(exp_path, expId, "/processed/SpikeTimes.mat");
    indicesMat = strcat(exp_path, expId, "/processed/Indices.mat");
    tagsMat = strcat(exp_path, expId, "/processed/Tags.mat");

    repetitionsMat = strcat(exp_path, expId, "/processed/Euler/Euler_RepetitionTimes.mat");
    stimMat = strcat(exp_path, expId, "/processed/Euler/Euler_Stim.mat");
    staMat = strcat(exp_path, expId, "/processed/STA/Sta.mat");

    %----- LOADs -------------------------------%

    load(repetitionsMat, "rep_begin_time_20khz", "rep_end_time_20khz")
    load(stimMat, "euler", "euler_sampler_rate")
    load(spikesMat, "SpikeTimes")
    load(staMat, "STAs")
    
    try
        load(indicesMat, "indices")
    catch
        disp("INFO: INDICES NOT FOUND. USING ALL CELLS")
        indices = 1:numel(SpikeTimes);
    end
    
    try
        load(tagsMat, "Tags")
    catch
        disp("WARNING: TAGGES NOT FOUND. RATING ALL CELLS AS [A]")
        Tags = ones(numel(SpikeTimes), 1) * 5;
    end
    
    
    %----- PARAMETERS ----------------------------%

    % experimental parameters
    params.meaRate = 20000; %Hz
    params.nSteps = rep_end_time_20khz(1) - rep_begin_time_20khz(1) + (1 * params.meaRate);

    % modeling parameters
    params.tBin = 0.05; % s
    params.binSize = params.tBin * params.meaRate;
    params.nTBins = round(params.nSteps / params.binSize);

    
    %----- PSTH --------------------------------------------%
    
    disp('  PSTH')
    [PSTH, XPSTH, MeanPSTH] = doPSTH(SpikeTimes, rep_begin_time_20khz, params.binSize, params.nTBins, params.meaRate, 1:numel(SpikeTimes));
    [chunkPSTH, chunkEuler] = extractEulerChunks(PSTH, 1/params.tBin, euler, euler_sampler_rate);
    
    disp('  STA')
    [temporal, spatial, indicesSTA] = decomposeSTA(STAs);
    
    ellipseAreas = zeros(numel(spatial), 1);
    for iS = 1:numel(spatial)
        if numel(spatial(iS).x) > 0
            ellipseAreas(iS,:) = polyarea(spatial(iS).x, spatial(iS).y);
        end
    end
    
    
    %----- VALID CELLS SELECTION ---------------------------%
    
    disp('  GROUPING')
    indicesTAGS = find(Tags>=acceptedLabels).';
    indicesPSTH = getValidIndicesPSTH(chunkPSTH);
    indices_1 = intersect(indicesPSTH, indicesSTA);
    indices_2 = intersect(indices, indicesTAGS);
    final_indices = intersect(indices_1, indices_2);
    indices_list{iExp} = final_indices;
    
    
    %----- DEFINE FEATURES ---------------------------%
         
    norm_psth = chunkPSTH(final_indices, :) ./ max(chunkPSTH(final_indices, :), [], 2);
    
    norm_tsta_baseline = temporal(final_indices, 1:6);
    norm_tsta = temporal(final_indices, 7:21);
    norm_tsta = norm_tsta - mean(norm_tsta_baseline, 2);
    norm_tsta = norm_tsta ./ std(norm_tsta, [], 2);
    
    norm_areas = ellipseAreas(final_indices) / max(ellipseAreas(final_indices));
    features = [norm_psth, norm_tsta, norm_areas];
    features_list{iExp} = features;
    
    temporalSTAs = [temporalSTAs; norm_tsta];
    spatialSTAs = [spatialSTAs, spatial(final_indices)];
    stas = [stas, STAs(final_indices)];
    psths = [psths;  chunkPSTH(final_indices, :)];
    
    disp('')
end

createDataset(datasetName, experiments, indices_list, features_list);
save(getDatasetMat(), 'experiments', 'temporalSTAs', 'spatialSTAs', 'stas', 'psths', 'params', '-append')

% output
clear
loadDataset()