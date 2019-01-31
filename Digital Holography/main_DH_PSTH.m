close all

% Load Spikes
load(getDatasetMat(), "spikes");
load(getDatasetMat(), "params");

% Load Triggers of DH Spots
exp_path = "/media/fran_tr/Elements/MEA_Experiments/";
expId = '20170614';
dh_path = strcat(exp_path, expId, "/processed/DHSpots/DHSpots_stim.mat");
load(dh_path, "evtTimes")

% PSTH parameters
initial_offset = 10000; % in time steps, equivalent to 0.5s
params.dh_PSTH.tBin = 0.05; % s
params.dh_PSTH.nTBins = 30;
params.dh_PSTH.binSize = params.tBin * params.meaRate;
    
% Compute Stimulus Repetitions
[rep_begin_time_20khz, rep_end_time_20khz] = getSpotsRepetitions(evtTimes, "repeated");
n_patterns = numel(rep_begin_time_20khz);

dh_PSTHs = zeros(numel(spikes), n_patterns, params.dh_PSTH.nTBins);
for i_pattern = 1:n_patterns
    rep_begin = rep_begin_time_20khz{i_pattern} - initial_offset;
        
    % PSTH for each pattern
    [dh_PSTH, dh_XPSTH, dh_MeanPSTH] = doPSTH(spikes, rep_begin, params.dh_PSTH.binSize, params.dh_PSTH.nTBins, params.meaRate, 1:numel(spikes));
    dh_PSTHs(:, i_pattern, :) = dh_PSTH;
     
%     % plots
%     rowCount = doRaster(spikes_indices, spikes, rep_begin, rep_end, 20000);
%     line([.5 .5], [0 rowCount], 'Color', [0.5 0.5 0.5], "LineWidth", 1.5, 'LineStyle','--');
%     line([1 1], [0 rowCount], 'Color', [0.5 0.5 0.5], "LineWidth", 1.5, 'LineStyle','--');
%     title(strcat("RASTER of DH pattern #", string(n_pattern)))
%     
%     figure()
%     plot(dh_XPSTH, dh_PSTH)
%     xlim([0, 1.5])
%     ylim([0, max(3, max(dh_PSTH(:)))])
% 
%     waitforbuttonpress
%     close all
end

save(getDatasetMat(), "dh_PSTHs", "params", "-append");
