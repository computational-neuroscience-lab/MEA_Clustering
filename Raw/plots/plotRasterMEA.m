function plotRasterMEA(spike_times, evt_timesteps, evt_binsize, evt_spacing, mea_channels, mea_map, mea_rate, n_max_rep)
    
timesteps_stim = evt_binsize + evt_spacing*2;
dt_stim = timesteps_stim / mea_rate;
    
for i_channel = mea_channels
    spikes = spike_times{i_channel};

    [x, y] = raster(spikes, evt_timesteps - evt_spacing, evt_timesteps + evt_binsize + evt_spacing, mea_rate);
    
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

if evt_spacing ~= 0
    onset_norm = evt_spacing / timesteps_stim;
    offset_norm = (timesteps_stim - evt_spacing) / timesteps_stim;

    for i_row = 1:16
        xline(onset_norm + i_row - 0.5, 'g--', 'LineWidth', 1);
        xline(offset_norm + i_row - 0.5, 'r--', 'LineWidth', 1);
    end
end