function doRaster(cell_Indices, SpikeTimes, rep_begin_time, rep_end_time, sampling_rate)

figure()

rowCount = 1;
for icell=cell_Indices
    
    spikes = SpikeTimes{icell};
    spikes_tot = [];
    y_spikes_tot = [];
    
    for r = 1:length(rep_begin_time)
        spikes_segment = and(spikes > rep_begin_time(r), spikes < rep_end_time(r));
        spikes_rep = spikes(spikes_segment) - rep_begin_time(r);
        
        if size(spikes_rep, 1) > 1
            spikes_rep = spikes_rep.';
        end
        
        spikes_tot = [spikes_tot, squeeze(spikes_rep)];
        y_spikes_tot = [y_spikes_tot, ones(1, length(spikes_rep)) * rowCount];
        rowCount = rowCount + 1;
    end    
    scatter(spikes_tot / sampling_rate, y_spikes_tot, '.')
    hold on
end