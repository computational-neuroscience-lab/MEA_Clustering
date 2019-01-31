function rowCount = doRaster(cell_Indices, SpikeTimes, rep_begin_time, rep_end_time, sampling_rate)

figure()
colors = getColors(numel(cell_Indices));

rowCount = 0;
for i = 1:numel(cell_Indices)
    
    icell = cell_Indices(i);
    color = colors(i, :);
    spikes = SpikeTimes{icell};
    
    for r = 1:length(rep_begin_time)
        rowCount = rowCount + 1;

        spikes_segment = and(spikes > rep_begin_time(r), spikes < rep_end_time(r));
        spikes_rep = (spikes(spikes_segment) - rep_begin_time(r));
        spikes_rep = spikes_rep(:).';
        
        y_spikes_rep = ones(1, length(spikes_rep)) * rowCount;
        
        scatter(spikes_rep / sampling_rate, y_spikes_rep, 25, color, 'filled')
        hold on
    end
        
    rowCount = rowCount + 5;
end