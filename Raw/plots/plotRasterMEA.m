function plotRasterMEA(spike_times, evt_begin_time, evt_end_time, mea_channels, mea_map, mea_rate, dt_stim, n_max_rep)

for i_channel = mea_channels
    spikes = spike_times{i_channel};

    [x, y] = raster(spikes, evt_begin_time, evt_end_time, mea_rate);
    
    x_norm = x / dt_stim;
    y_norm = y / n_max_rep;
    
    x_plot = x_norm + mea_map(i_channel, 1) - 0.5;
    y_plot = y_norm + mea_map(i_channel, 2) - 0.5;
    
    if mod(mea_map(i_channel, 1) - mea_map(i_channel, 2), 2)
        c = [.6, .4, .6];
    else
        c = [.4, .4, .7];
    end
    
    scatter(x_plot, y_plot, 30, c, '.')  
end