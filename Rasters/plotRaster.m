function rowCount = plotRaster(cell_indices, SpikeTimes, rep_begin_time, rep_end_time, sampling_rate, point_size)

if ~exist('point_size', 'var')
    point_size = 10;
end
colors = getColors(numel(cell_indices));

rowCount = 0;
ticks = zeros(numel(cell_indices), 1);
for i = 1:numel(cell_indices)
    
    icell = cell_indices(i);
    color = colors(i, :);
    spikes = SpikeTimes{icell};
    
    ticks(i) = rowCount;
    for r = 1:length(rep_begin_time)
        rowCount = rowCount - 1;

        spikes_segment = and(spikes > rep_begin_time(r), spikes < rep_end_time(r));
        spikes_rep = (spikes(spikes_segment) - rep_begin_time(r));
        spikes_rep = spikes_rep(:).';
        
        y_spikes_rep = ones(1, length(spikes_rep)) * rowCount;
        
        scatter(spikes_rep / sampling_rate, y_spikes_rep, point_size, color, 'filled')
        hold on
    end
        
    rowCount = rowCount - 5;
end

yticks(flip(ticks))
yticklabels(flip(cell_indices))

ylim([rowCount, 0])
xlabel("Time (s)")
ylabel("Cells Spiking Activity")