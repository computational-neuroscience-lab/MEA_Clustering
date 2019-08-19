% function extractAll(expId)

expId = char("18_06_2019_checker");
rawPath = [dataPath(), '/', expId, '/sorted/CONVERTED'];
varsPath = [dataPath(), '/', expId, '/processed/'];
stimsOrderFile =  [dataPath(), '/', expId, '/processed/stims_order.txt'];
results_suffix = '';

% File Paths
rawFile = strcat(rawPath, '.raw');
templatesFile = strcat(rawPath, '/CONVERTED.templates', results_suffix, '.hdf5');
resultsFile = strcat(rawPath, '/CONVERTED.result', results_suffix, '.hdf5');
% stimsOrderFile = strcat(varsPath, "stims_order.txt");

% Spike Times
try
    load(strcat(varsPath, 'SpikeTimes.mat'), 'SpikeTimes')
    disp("Spike Times Loaded")
catch
    SpikeTimes = extractSpikeTimes(resultsFile);
    save(strcat(varsPath, 'SpikeTimes.mat'), 'SpikeTimes')
    disp("Spike Times Computed")
end

% Tags
try
    Tags = extractTags(templatesFile);
    save(strcat(varsPath, 'Tags.mat'), 'Tags')
catch
   disp("WARNING: Tags not found")
end

% Stim Triggers
try
    load(strcat(varsPath,'EvtTimes.mat'), 'evtTimes')
    disp("EvtTimes Loaded")
catch
    try
        load(strcat(varsPath,'StimChannel_data.mat'), 'stimChannel_data')
    catch
        stimChannel_data = extractDMD_Data(rawFile);
        save(strcat(varsPath,'StimChannel_data.mat'), 'stimChannel_data', '-v7.3');
    end
    evtTimes = extractDMDTriggers(stimChannel_data);
    save(strcat(varsPath,'EvtTimes.mat'), 'evtTimes')
end

% Retrieve the order of Stimulations
stims_order = importdata(stimsOrderFile);
checker_index = contains(stims_order, 'CHECKERBOARD');
euler_index = contains(stims_order, 'EULER');

% Checkerboard Repetitions
Frames = evtTimes{checker_index}.evtTimes_begin;
checkerboard_mat = strcat(stimPath, '/Checkerboard/checkerboard.mat');
[check_begin_time_20khz, check_end_time_20khz] = getCheckerboardRepetitions(Frames, checkerboard_mat);
save(strcat(varsPath, 'CheckerBoard/Checkerboard_RepetitionTimes.mat'), 'check_begin_time_20khz', 'check_end_time_20khz')

% Euler Repetitions
load(strcat(varsPath,'Euler/Euler_Stim.mat'), 'euler')
euler_evtTime = evtTimes{euler_index}.evtTimes_begin;
euler_n_steps = length(euler);
[rep_begin_time_20khz, rep_end_time_20khz] = getConsecutiveStimRepetitions(euler_evtTime, euler_n_steps);
save(strcat(varsPath,'Euler/Euler_RepetitionTimes.mat'), 'rep_begin_time_20khz', 'rep_end_time_20khz')
 
% Spike Sorting Repetitions
rep_begin_time{1} = rep_begin_time_20khz;
rep_end_time{1} = rep_end_time_20khz;
save(strcat(varsPath, 'CONVERTED.stim'), 'rep_begin_time', 'rep_end_time')

% STA
save(strcat(varsPath, 'STA/Frames.mat'), 'Frames')
save(strcat(varsPath, 'STA/SpikeTimes.data'), 'SpikeTimes')


% Tests
meaRate = 20000; % Hz
tBin = 0.05;% s

% Test Checkerboard
figure
doPlotRaster(1:10, SpikeTimes, check_begin_time_20khz, check_end_time_20khz, meaRate)
suptitle("CheckerBoard Raster")

% Test Euler
figure
alfa = .1;
n_bins = round((rep_end_time_20khz(1) - rep_begin_time_20khz(1)) / (tBin*meaRate));
[psth, xpsth, mean_psth, firing_rates] = doSmoothPSTH(SpikeTimes, rep_begin_time_20khz, tBin*meaRate, n_bins, meaRate, 1:numel(SpikeTimes), alfa);
plot(xpsth, psth)
suptitle("Euler Smooth PSTH")

figure
doPlotRaster(1:10, SpikeTimes, rep_begin_time_20khz, rep_end_time_20khz, meaRate)
suptitle("Euler Raster")
