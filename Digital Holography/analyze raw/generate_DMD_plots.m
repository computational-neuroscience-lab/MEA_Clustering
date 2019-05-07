close all
clear
clc

% Load Euler Stim
load("euler_stim/EulerStim180530.vec")
euler_length = 999;
euler_stim = EulerStim180530(2:end, 2);
euler_rep = euler_stim(1:euler_length);

% Load Spike Trains
filename = 'euler_data/euler_sppa0001_';
SpikeTimes = cell(1, 256);
for ich = 1:256
    if ich < 10
        a = importdata([filename '0' int2str(ich) '.dat']);
    else
        a = importdata([filename int2str(ich) '.dat']);
    end
    if isfield(a, 'data')
        SpikeTimes{ich} = a.data;
        SpikeTimes{ich} = SpikeTimes{ich}(:, 1);
    end
end

% Compute Trigger Times and Repetitions
cells_idx = [1:256];
dmd_id = 127;
TrigTimes = SpikeTimes{dmd_id};
stimSampling = median(diff(TrigTimes));
rep_begin_time = TrigTimes(1:euler_length:end);
rep_dts = diff(rep_begin_time);
rep_dt = median(rep_dts);
n_reps = length(rep_dts);

% Do PSTHs
binSize = .05;
nTBins = round(rep_dt / binSize);
[PSTH, XPSTH, ~] = doPSTH(SpikeTimes, rep_begin_time(1), binSize*30, nTBins, 1, cells_idx);   

% Resample Euler Stim for plots
euler_resampled = interp1(1:euler_length, euler_rep, 1:binSize/stimSampling:euler_length);
euler_resampled = (euler_resampled - euler_resampled(end));
euler_resampled = euler_resampled / max(euler_resampled) * 10;

% Plot Rasters
l_raster = 16;
for i = 1:l_raster:length(cells_idx)
    
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 800;
    horz = 1200;
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
    
    c_idx = cells_idx(i:(i+l_raster-1));
    doRaster(c_idx, SpikeTimes, rep_begin_time, rep_begin_time+rep_dt, 1, 5)
    title_txt = strcat("Electrodes from  #", int2str(c_idx(1)), " to #", int2str(c_idx(end)));
    title(title_txt)
    
    raster_filename = strcat("plots/raster_", int2str(c_idx(1)), "to", int2str(c_idx(end)));
    saveas(gcf, raster_filename, 'jpg');
    close;
end

% Plot PSTHs
for i = 1:length(cells_idx)
    
    figure()
    
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 800;
    horz = 1200;
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
    
    plot(XPSTH, euler_resampled, 'Color', [0.3, 0.3, 0.3], "LineWidth", 1.2)
    hold on
    plot(XPSTH, PSTH(i, :), 'Blue', "LineWidth", 1.8);
    xlabel("Time (s)");
    ylabel("Firing Rate (Hz)");  
    ylim([-20, +125])
    title(strcat("Electrode #", int2str(cells_idx(i))))
    
    psth_filename = strcat("plots/psth_", int2str(cells_idx(i)));
    saveas(gcf, psth_filename, 'jpg');
    close;
end