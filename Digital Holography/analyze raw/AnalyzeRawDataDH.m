% Show raster based on threshold detection after artifact removal

% Parameters
idx_frame = [1, 4, 8, 12, 16]; % which pattern number do you want to display the responses to? You can try all, the pattern shape will be displayed by the code.
n_reps = 10; % How many trials max do you want to display ?

mea_rate = 20000;
time_before = 0.5 * mea_rate; % How much time before the stim plotted ? In samples (seconds*sampling rate)
time_after = 0.5 * mea_rate; % Muw much time after ? Same unit
duration_stim = 0.5 * mea_rate; % Duration of the stimulus, to modify. Same unit
duration_raster = duration_stim + time_after + time_before;

window_smooth = 500; % Parameter for smoothing - don't worry about it, this is for artifact removal
detect_tresh = 6; % To detect spikes, the threshold is set at mean+ThresFactor*(standard dev). Should be fine for all recordings.

raw_file = 'DHBIPOL.raw';
mea_file = 'PositionsMEA.mat';
stim_file = 'DHFrames.mat'; 
dh_data_file = 'DHDATA.mat';
triggers_file = 'DHTimes.mat';

load(mea_file, 'Positions');

% Get the triggers
try
    % load the triggers
    load(triggers_file, 'StimBegin', 'StimEnd')
catch

    % if the triggers aren't found, generate them
    try
        load(dh_data_file, 'dh_data')
    catch
        dh_data = extractDH_Data([raw_filename '.raw']);
        save(dh_data_file, 'dh_data')
    end
    dh_triggers = extractDHTriggers(dh_data);

    StimBegin = dh_triggers{1}.evtTimes_begin;
    StimEnd = dh_triggers{1}.evtTimes_end;
    save(triggers_file, 'StimBegin', 'StimEnd')
end
 

% Get the repetitions
[all, single, repeated, uniques] = getDHSpotsRepetitions(StimBegin, StimEnd, stim_file);

for id_frame = idx_frame
    stim_repeats = single.rep_begin{id_frame};
    stim_repeats = stim_repeats(1:min(n_reps, length(stim_repeats)));
    chosen_pattern = single.frames(id_frame, :)

    % Get the multi unit data
    multi_unit = extractMultiUnit_raw(raw_file, stim_repeats - time_before, duration_raster);
    spike_trains = getMultiUnitSpikeTimes(multi_unit, duration_stim, time_before, time_after, detect_tresh, window_smooth);

    % Create the raster
    doPlotRasterMEA(spike_trains, Positions, duration_raster, time_before, time_after)


    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 900;
    horz = 900;
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
    
    saveas(gcf, strcat('1spot_#', string(id_frame)),'jpg')
    close;
end
