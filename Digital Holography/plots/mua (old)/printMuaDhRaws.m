% Params
for dh_session = 5

    mea_rate = 20000;
    spacing = 0.25 * mea_rate;
    chunk_size = 0.5 * mea_rate + spacing*2;
    dead_electrodes = 30;
    elec_radius = 30;
    suffix = ['_' num2str(dh_session)];

    exp_id = '20191011_grid';

    raw_1 = [dataPath '/' exp_id '/sorted/CONVERTED.raw'];
%     raw_2 = [dataPath '/' exp_id '/sorted/CONVERTED_UNFILTERED.raw'];
    dh_repetitions_file = [dataPath '/' exp_id '/processed/DH/DHRepetitions' suffix '.mat'];
    dh_spots_file = [dataPath, '/' exp_id '/processed/DH/DHCoords.mat'];
    rasters_folder = [dataPath '/' exp_id '/processed/DH/Plots/MUA_Raws'];

    mea_file = 'PositionsMEA';

    load(mea_file, 'Positions')
    load(dh_repetitions_file, 'single_begin_time', 'single_frames')
    load(dh_spots_file, 'PatternCoords_MEA')

    n_patterns = numel(single_begin_time);

    x = PatternCoords_MEA(:, 1)/elec_radius;
    y = PatternCoords_MEA(:, 2)/elec_radius;

    for i_pattern = 1:n_patterns

        spot = find(single_frames(i_pattern, :));
        pattern_triggers = single_begin_time{i_pattern};
        t = pattern_triggers(1);

        plotMEA();
        plotGridMEA()
%         plotFileDataMEA(raw_2, t - spacing, chunk_size, 'blue', dead_electrodes);
        plotFileDataMEA(raw_1, t - spacing, chunk_size, 'cyan', dead_electrodes);


        scatter(x, y, 'g');
        scatter(x(spot), y(spot), 'g', 'Filled');

        raster_name = ['dh' num2str(dh_session) '_mua_raw_spot' num2str(i_pattern)];
        title(raster_name, 'Interpreter', 'None')

%         export_fig([tmpPath '/' raster_name '.svg'])
%         saveas(gcf, [tmpPath '/' raster_name],'svg');
%         movefile([tmpPath '/' raster_name '.svg'], rasters_folder);
        pause();
        close;
    end
end

     

