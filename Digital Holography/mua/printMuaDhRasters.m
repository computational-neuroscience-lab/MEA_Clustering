% Params
dh_session = 6;

mea_rate = 20000;
mea_channels = [1:126, 129:254]; % excluded trigger electrodes
n_max_rep = 20;
dt_stim = 0.5;
elec_radius = 30;

% Paths
exp_id = '20191011_grid';
exp_folder = [dataPath() '/' exp_id '/'];
processed_folder = [exp_folder 'processed/'];
dh_folder = [processed_folder 'DH/'];
rasters_folder = [processed_folder 'DH/Plots/MUA_Rasters'];

mea_file = [exp_folder 'PositionsMEA.mat'];
spikes_file = [processed_folder  'muaSpikeTimes.mat'];
repetitions_file = [dh_folder 'DHRepetitions_' num2str(dh_session) '.mat'];
coords_file = [dh_folder 'DHCoords.mat'];

% Load
load(mea_file, 'Positions');
load(spikes_file, 'spike_times_dt');
load(repetitions_file, 'single_begin_time', 'single_end_time', 'single_frames');
load(coords_file, 'PatternCoords_MEA');

mea_map = double(Positions);
x_spots = PatternCoords_MEA(:, 1)/elec_radius;
y_spots = PatternCoords_MEA(:, 2)/elec_radius;

% Do
for i_pattern = 1:numel(single_begin_time)
    
    spot = find(single_frames(i_pattern, :));
    
    plotMEA()
    plotGridMEA()
    plotRasterMEA(spike_times_dt, single_begin_time{i_pattern}, ...
        single_end_time{i_pattern}, mea_channels, mea_map, ...
        mea_rate, dt_stim, n_max_rep)
    
    spot_plot = scatter(x_spots(spot), y_spots(spot), 100, 'r', 'Filled');
    spot_plot.MarkerFaceAlpha = 0.5;

    raster_name = ['dh' num2str(dh_session) '_mua_raster_spot' num2str(i_pattern)];
    title(raster_name, 'Interpreter', 'None')
    saveas(gcf, [tmpPath '/' raster_name],'jpg');
    movefile([tmpPath '/' raster_name '.jpg'], rasters_folder);
    close;
end
