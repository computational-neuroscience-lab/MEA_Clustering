function extractAll(expId)

rawPath = strcat('/media/fran_tr/Elements/MEA_Experiments/', expId, '/sorted/CONVERTED');
dataPath = strcat('/media/fran_tr/Elements/MEA_Experiments/', expId, '/processed/');
results_suffix = '';

% File Paths
rawFile = strcat(rawPath, '.raw');
templatesFile = strcat(rawPath, '/CONVERTED.templates', results_suffix, '.hdf5');
resultsFile = strcat(rawPath, '/CONVERTED.result', results_suffix, '.hdf5');
stimsOrderFile = strcat(dataPath, "stims_order.txt");

% Spike Times
try
    load(strcat(dataPath, 'SpikeTimes.mat'), 'SpikeTimes')
    disp("Spike Times Loaded")
catch
    SpikeTimes = extractSpikeTimes(resultsFile);
    save(strcat(dataPath, 'SpikeTimes.mat'), 'SpikeTimes')
    disp("Spike Times Computed")
end

% Tags
try
    Tags = extractTags(templatesFile);
    save(strcat(dataPath, 'Tags.mat'), 'Tags')
catch
   disp("WARNING: Tags not found")
end

% Stim Triggers
% try
    load(strcat(dataPath,'EvtTimes.mat'), 'evtTimes')
    disp("EvtTimes Loaded")
% catch
%     try
%         load(strcat(dataPath,'StimChannel_data.mat'), 'stimChannel_data')
%     catch
%         stimChannel_data = extractStimData(rawFile);
%         save(strcat(dataPath,'StimChannel_data.mat'), 'stimChannel_data', '-v7.3');
%     end
%     evtTimes = extractStimTriggers(stimChannel_data);
%     save(strcat(dataPath,'EvtTimes.mat'), 'evtTimes')
% end

% Retrieve the order of Stimulations
stims_order = importdata(stimsOrderFile);
checker_index = contains(stims_order, 'CHECKERBOARD');
euler_index = contains(stims_order, 'EULER');

% Checkerboard Repetitions
Frames = evtTimes{checker_index};
[check_begin_time_20khz, check_end_time_20khz] = getCheckerboardRepetitions(Frames);
save(strcat(dataPath, 'CheckerBoard/Checkerboard_RepetitionTimes.mat'), 'check_begin_time_20khz', 'check_end_time_20khz')

% Euler Repetitions
load(strcat(dataPath,'Euler/Euler_Stim.mat'), 'euler', 'euler_sampler_rate')
euler_evtTime = evtTimes{euler_index};
euler_n_steps = length(euler);
[rep_begin_time_20khz, rep_end_time_20khz] = getConsecutiveStimRepetitions(euler_evtTime, euler_n_steps);
save(strcat(dataPath,'Euler/Euler_RepetitionTimes.mat'), 'rep_begin_time_20khz', 'rep_end_time_20khz')
 
% Spike Sorting Repetitions
rep_begin_time{1} = rep_begin_time_20khz;
rep_end_time{1} = rep_end_time_20khz;
save(strcat(dataPath, 'CONVERTED.stim'), 'rep_begin_time', 'rep_end_time')

% STA
save(strcat(dataPath, 'STA/Frames.mat'), 'Frames')
save(strcat(dataPath, 'STA/SpikeTimes.data'), 'SpikeTimes')

% Test Checkerboard
params.meaRate = 20000; %Hz
doRaster(35:45, SpikeTimes, check_begin_time_20khz, check_end_time_20khz, params.meaRate)
suptitle("CheckerBoard Raster")

% Test Euler
test_psth(rep_begin_time_20khz, rep_end_time_20khz, SpikeTimes, euler, euler_sampler_rate);
suptitle("Euler PSTH")

doRaster(35:45, SpikeTimes, rep_begin_time_20khz, rep_end_time_20khz, params.meaRate)
suptitle("Euler Raster")

