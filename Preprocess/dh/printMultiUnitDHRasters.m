% Show raster based on threshold detection after artifact removal
close all

% Parameters
expId = '20190510';
dh_fvs = 4;

idx_frame = [1, 4, 8, 12, 16]; % which pattern number do you want to display the responses to? You can try all, the pattern shape will be displayed by the code.
n_reps = 10; % How many trials max do you want to display ?

mea_rate = 20000;
time_before = 0.5 * mea_rate; % How much time before the stim plotted ? In samples (seconds*sampling rate)
time_after = 0.5 * mea_rate; % Muw much time after ? Same unit
duration_stim = 0.5 * mea_rate; % Duration of the stimulus, to modify. Same unit
duration_raster = duration_stim + time_after + time_before;

window_smooth = 500; % Parameter for smoothing - don't worry about it, this is for artifact removal
detect_tresh = 6; % To detect spikes, the threshold is set at mean+ThresFactor*(standard dev). Should be fine for all recordings.

ss = get(0,'screensize');
width = ss(3);
height = ss(4);
vert = 1600;
horz = 1600;
        
raw_file = [dataPath() '/' expId '/sorted/CONVERTED.raw'];
mea_file = [dataPath() '/' expId '/PositionsMEA.mat'];
load(mea_file, 'Positions');

for dh_fv = dh_fvs
    repetitionsMultiFile = [dataPath() '/' expId '/processed/DH/' 'DH' num2str(dh_fv) '_reps_multi.mat'];
    load(repetitionsMultiFile, "rep_begin_time", "rep_end_time", "rep_frames");   
    for id_frame = idx_frame
        rasterFile = [dataPath() '/' expId '/processed/DH/Rasters/DH' num2str(dh_fv) '/Nspot_#', num2str(id_frame)];
        stim_repeats = rep_begin_time{id_frame};
        stim_repeats = stim_repeats(1:min(n_reps, length(stim_repeats)));
        chosen_pattern = rep_frames(id_frame, :)

        % Get the multi unit data
        multi_unit = extractMultiUnit_raw(raw_file, stim_repeats - time_before, duration_raster);
        spike_trains = getMultiUnitSpikeTimes(multi_unit, duration_stim, time_before, time_after, detect_tresh, window_smooth);

        % Create the raster
        doPlotRasterMEA(spike_trains, Positions, duration_raster, time_before, time_after)
        set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);

        saveas(gcf, rasterFile, 'jpg')
        close;
    end


    repetitionsSingleFile = [dataPath() '/' expId '/processed/DH/' 'DH' num2str(dh_fv) '_reps_single.mat'];
    load(repetitionsSingleFile, "rep_begin_time", "rep_end_time", "rep_frames");
    for id_frame = idx_frame
        rasterFile = [dataPath() '/' expId '/processed/DH/Rasters/DH' num2str(dh_fv) '/1spot_#', num2str(id_frame)];

        stim_repeats = rep_begin_time{id_frame};
        stim_repeats = stim_repeats(1:min(n_reps, length(stim_repeats)));
        chosen_pattern = rep_frames(id_frame, :)

        % Get the multi unit data
        multi_unit = extractMultiUnit_raw(raw_file, stim_repeats - time_before, duration_raster);
        spike_trains = getMultiUnitSpikeTimes(multi_unit, duration_stim, time_before, time_after, detect_tresh, window_smooth);

        % Create the raster
        doPlotRasterMEA(spike_trains, Positions, duration_raster, time_before, time_after)
        set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);

        saveas(gcf, rasterFile, 'jpg')
        close;
    end
end