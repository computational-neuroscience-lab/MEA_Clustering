% function extractAll(exp_id)

exp_id = '20191011_grid';
exp_id = char(exp_id);
mea_channels = [1:126 129:254];

% Tests Params
meaRate = 20000; % Hz
tBin = 0.05;% s

% File Paths
raw_path = [dataPath(), '/' exp_id '/sorted'];
vars_path = [dataPath(), '/' exp_id '/processed'];

raw_file = [raw_path '/CONVERTED.raw'];
results_file = [raw_path '/CONVERTED/CONVERTED.mua.hdf5'];
stims_order_file = [vars_path '/' 'stims_order.txt'];

% Spike Times
% try
%     load([vars_path '/' 'muaSpikeTimes.mat'], 'SpikeTimes')
%     disp("Spike Times Loaded")
% catch
%     SpikeTimes = readMUASpikeTimes(results_file, mea_channels);    
%     save([tmpPath() '/' 'SpikeTimes.mat'], 'SpikeTimes')
%     movefile([tmpPath()  '/' 'SpikeTimes.mat'], vars_path)
%     disp("Spike Times Computed")
% end

% Stim Triggers
try
    load([vars_path '/' 'EvtTimes.mat'], 'evtTimes')
    disp("EvtTimes Loaded")
catch
    try
        load([vars_path '/' 'StimChannel_data.mat'], 'stimChannel_data')
    catch
        disp('reading dmd data...')
        stimChannel_data = extractDataDMD(raw_file);
        save([tmpPath() '/' 'StimChannel_data.mat'], 'stimChannel_data', '-v7.3');
        movefile([tmpPath() '/' 'StimChannel_data.mat'], vars_path);
    end
    disp('extracting dmd triggers...')
    evtTimes = extractDMDTriggers(stimChannel_data);
    save([tmpPath() '/' 'EvtTimes.mat'], 'evtTimes')
    movefile([tmpPath() '/' 'EvtTimes.mat'], vars_path)
end

% Retrieve the order of Stimulations
stims_order = importdata(stims_order_file);
checker_index = contains(stims_order, 'CHECKERBOARD');
euler_index = contains(stims_order, 'EULER');

% Checkerboard Repetitions
if any(checker_index)
    Frames = evtTimes{checker_index}.evtTimes_begin;
    checkerboard_mat = strcat(stimPath, '/Checkerboard/checkerboard.mat');
    [check_begin_time_20khz, check_end_time_20khz] = getCheckerboardRepetitions(Frames, checkerboard_mat);
    save([tmpPath() '/' 'Checkerboard_RepetitionTimes.mat'], 'check_begin_time_20khz', 'check_end_time_20khz')
    movefile([tmpPath() '/' 'Checkerboard_RepetitionTimes.mat'], [vars_path '/' 'CheckerBoard'])
    
    % Test Checkerboard
    figure
    plotRaster(100:110, SpikeTimes, check_begin_time_20khz, check_end_time_20khz, meaRate)
    suptitle("CheckerBoard Raster")
        
    % Spike Sorting Repetitions
    rep_begin_time{1} = check_begin_time_20khz;
    rep_end_time{1} = check_end_time_20khz;
    save([tmpPath() '/' 'CONVERTED.stim'], 'rep_begin_time', 'rep_end_time')
    movefile([tmpPath() '/' 'CONVERTED.stim'], vars_path)
end

% Euler Repetitions
if any(euler_index)
    load(strcat(vars_path,'Euler/Euler_Stim.mat'), 'euler')
    euler_evtTime = evtTimes{euler_index}.evtTimes_begin;
    euler_n_steps = length(euler);
    [rep_begin_time_20khz, rep_end_time_20khz] = getConsecutiveStimRepetitions(euler_evtTime, euler_n_steps);
    save([tmpPath() '/' 'Euler_RepetitionTimes.mat'], 'rep_begin_time_20khz', 'rep_end_time_20khz')
    movefile([tmpPath() '/' 'Euler_RepetitionTimes.mat'], [var_path '/' 'Euler'])

    % Test Euler
    figure
    alfa = .1;
    n_bins = round((rep_end_time_20khz(1) - rep_begin_time_20khz(1)) / (tBin*meaRate));
    [psth, xpsth, ~, ~] = doSmoothPSTH(SpikeTimes, rep_begin_time_20khz, tBin*meaRate, n_bins, meaRate, 1:numel(SpikeTimes), alfa);
    plot(xpsth, psth)
    suptitle("Euler Smooth PSTH")

    figure
    plotRaster(1:10, SpikeTimes, rep_begin_time_20khz, rep_end_time_20khz, meaRate)
    suptitle("Euler Raster")
    
    % Spike Sorting Repetitions
    rep_begin_time{1} = rep_begin_time_20khz;
    rep_end_time{1} = rep_end_time_20khz;
    save([tmpPath() '/' 'CONVERTED.stim'], 'rep_begin_time', 'rep_end_time')
    movefile([tmpPath() '/' 'CONVERTED.stim'], vars_path)
end

% STA
save([tmpPath() '/' 'Frames.mat'], 'Frames')
save([tmpPath() '/' 'SpikeTimes.data'], 'SpikeTimes')

movefile([tmpPath() '/' 'Frames.mat'], [vars_path '/' 'STA'])
movefile([tmpPath() '/' 'SpikeTimes.data'], [vars_path '/' 'STA'])

