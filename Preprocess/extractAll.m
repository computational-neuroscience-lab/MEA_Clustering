
% Parameters
exp_id = '20200131_dh';
sorted = false;
results_suffix = '-final';
mea_rate = 20000; % Hz

% Plots Params
tBin = 0.05;% s

% Folder Paths
exp_id = char(exp_id);
raw_path = [dataPath(), '/' exp_id '/sorted/CONVERTED'];
vars_path = [dataPath(), '/' exp_id '/processed'];
checker_path = [vars_path() '/CheckerBoard'];
euler_path = [vars_path() '/Euler'];
sta_path = [vars_path() '/STA'];

% File Paths
raw_file = [raw_path '.raw'];
templates_file = [raw_path '/CONVERTED.templates' results_suffix '.hdf5'];
results_file = [raw_path '/CONVERTED.result' results_suffix, '.hdf5'];
mua_file = [raw_path '/CONVERTED.mua.hdf5'];
stims_order_file = [vars_path '/stims_order.txt'];

% Stim Triggers
try
    load([vars_path '/EvtTimes.mat'], 'evtTimes')
    disp("EvtTimes Loaded")
catch
    try
        load([vars_path '/StimChannel_data.mat'], 'stimChannel_data')
    catch
        stimChannel_data = extractDataDMD(raw_file);
        save([tmpPath() '/StimChannel_data.mat'], 'stimChannel_data', '-v7.3');
        movefile([tmpPath() '/StimChannel_data.mat'], vars_path);
    end
    evtTimes = extractDMDTriggers(stimChannel_data);
    save([tmpPath() '/EvtTimes.mat'], 'evtTimes')
    movefile([tmpPath() '/EvtTimes.mat'], vars_path)
end

% Spike Times
if sorted
    try
        load([vars_path '/SpikeTimes.mat'], 'SpikeTimes')
        disp("Spike Times Loaded")
    catch
        SpikeTimes = readSpikeTimes(results_file);
        save([tmpPath() '/SpikeTimes.mat'], 'SpikeTimes')
        movefile([tmpPath()  '/SpikeTimes.mat'], vars_path)
        disp("Spike Times Computed")
    end
    
    % Tags
    try
        Tags = readTags(templates_file);
        save([tmpPath() '/Tags.mat'], 'Tags')
        movefile([tmpPath()  '/Tags.mat'], vars_path)
    catch
        disp("WARNING: Tags not found")
    end
else
    try
        load([vars_path '/' 'muaSpikeTimes.mat'], 'SpikeTimes')
        disp("Spike Times Loaded")
    catch
        SpikeTimes = readMUASpikeTimes(mua_file, mea_channels);
        save([tmpPath() '/' 'muaSpikeTimes.mat'], 'SpikeTimes')
        movefile([tmpPath()  '/' 'muaSpikeTimes.mat'], vars_path)
        disp("Spike Times Computed")
    end
end

% Retrieve the order of Stimulations
stims_order = importdata(stims_order_file);
checker_index = contains(stims_order, 'CHECKERBOARD');
euler_index = contains(stims_order, 'EULER');

% Checkerboard Repetitions
if any(checker_index)
    Frames = evtTimes{checker_index}.evtTimes_begin;
    checkerboard_mat = [stimPath '/Checkerboard/checkerboard.mat'];
    [rep_begin, rep_end] = getCheckerboardRepetitions(Frames, checkerboard_mat);
    save([tmpPath() '/' 'Checkerboard_RepetitionTimes.mat'], 'rep_begin', 'rep_end')
    movefile([tmpPath() '/' 'Checkerboard_RepetitionTimes.mat'], checker_path)
    
    % Test Checkerboard
    figure
    plotRaster(120:130, SpikeTimes, rep_begin, rep_end, mea_rate);
    suptitle("CheckerBoard Raster")
    
    % Spike Sorting Repetitions
    rep_begin_time{1} = rep_begin;
    rep_end_time{1} = rep_end;
    save([tmpPath() '/' 'CONVERTED.stim'], 'rep_begin_time', 'rep_end_time')
    movefile([tmpPath() '/' 'CONVERTED.stim'], vars_path)
end

% Euler Repetitions
if any(euler_index)
    load([euler_path '/Euler_Stim.mat'], 'euler')
    euler_evtTime = evtTimes{euler_index}.evtTimes_begin;
    euler_n_steps = length(euler);
    [rep_begin, rep_end] = getConsecutiveStimRepetitions(euler_evtTime, euler_n_steps);
    save([tmpPath() '/' 'Euler_RepetitionTimes.mat'], 'rep_begin', 'rep_end')
    movefile([tmpPath() '/' 'Euler_RepetitionTimes.mat'], euler_path)
    
    % Test Euler
    figure
    alfa = .1;
    n_bins = round((rep_end(1) - rep_begin(1)) / (tBin*mea_rate));
    [psth, xpsth, ~, ~] = doSmoothPSTH(SpikeTimes, rep_begin, tBin*mea_rate, n_bins, mea_rate, 1:numel(SpikeTimes), alfa);
    plot(xpsth, psth)
    suptitle("Euler Smooth PSTH")
    
    figure
    plotRaster(1:10, SpikeTimes, rep_begin, rep_end, mea_rate);
    suptitle("Euler Raster")
    
    % Spike Sorting Repetitions
    rep_begin_time{1} = rep_begin;
    rep_end_time{1} = rep_end;
    save([tmpPath() '/' 'CONVERTED.stim'], 'rep_begin_time', 'rep_end_time')
    movefile([tmpPath() '/' 'CONVERTED.stim'], vars_path)
end

% STA
save([tmpPath() '/' 'Frames.mat'], 'Frames')
movefile([tmpPath() '/' 'Frames.mat'], sta_path)

if sorted
    save([tmpPath() '/' 'SpikeTimes.data'], 'SpikeTimes')
    movefile([tmpPath() '/' 'SpikeTimes.data'], sta_path)
else
    save([tmpPath() '/' 'muaSpikeTimes.data'], 'SpikeTimes')
    movefile([tmpPath()  '/' 'muaSpikeTimes.data'], sta_path)
end


