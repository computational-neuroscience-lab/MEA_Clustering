clear

datasetName = "MEA_ALL_ABC_17ago";
expId_list = {"170614", "180209", "180705"};
acceptedLabels = 3;

indices_list = {};
features_list = {};
temporalSTAs = [];
spatialSTAs = [];
stas = [];
psths = [];

for iExp = 1:numel(expId_list)
    expId = expId_list{iExp};
    disp(strcat("Experiment #", string(iExp)))

    
    %----- PATHS ---------------------------%

    repetitionsMat = strcat("Experiments/", expId, "/Euler/RepetitionTimes.mat");
    stimMat = strcat("Experiments/", expId, "/Euler/euler.mat");
    spikesMat = strcat("Experiments/", expId, "/SpikeTimes.mat");
    staMat = strcat("Experiments/", expId, "/Sta.mat");
    indicesMat = strcat("Experiments/", expId, "/Indices.mat");
    tagsMat = strcat("Experiments/", expId, "/Tagged.mat");


    %----- LOADs -------------------------------%

    load(repetitionsMat, "rep_begin_time_20khz", "rep_end_time_20khz")
    load(stimMat, "euler", "freqEuler")
    load(spikesMat, "SpikeTimes")
    load(staMat, "STAs")
    
    try
        load(indicesMat, "indices")
    catch
        indices = 1:numel(SpikeTimes);
    end
    
    try
        load(tagsMat, "Tagged")
    catch
        Tagged = ones(numel(SpikeTimes), 1) * 5;
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
    [chunkPSTH, chunkEuler] = extractEulerChunks(PSTH, 1/params.tBin, euler, freqEuler);
    
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
    indicesTAGS = find(Tagged>=acceptedLabels).';
    indicesPSTH = getValidIndicesPSTH(chunkPSTH);
    indices_1 = intersect(indicesPSTH, indicesSTA);
    indices_2 = intersect(indices, indicesTAGS);
    final_indices = intersect(indices_1, indices_2);
    indices_list{iExp} = final_indices;
    
    
    %----- DEFINE FEATURES ---------------------------%
      
    temporalSTAs = [temporalSTAs; temporal(final_indices, :)];
    spatialSTAs = [spatialSTAs, spatial(final_indices)];
    stas = [stas, STAs(final_indices)];
    
    psths = [psths;  chunkPSTH(final_indices, :)];
    
    norm_psth = chunkPSTH(final_indices, :) ./ max(chunkPSTH(final_indices, :), [], 2);
    norm_tsta = temporal(final_indices, :) ./ max(abs(temporal(final_indices, :)));
    norm_areas = ellipseAreas(final_indices) / max(ellipseAreas(final_indices));
    features = [norm_psth, norm_tsta, norm_areas];
    features_list{iExp} = features;
end

createDataset(datasetName, expId_list, indices_list, features_list);
save(getDatasetMat(), 'temporalSTAs', 'spatialSTAs', 'stas', 'psths', 'params', '-append')

% output
clear
loadDataset()