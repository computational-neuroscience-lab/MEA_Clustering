function SpikeTrains = getMultiUnitSpikeTimes(multi_unit, stim_duration, time_before, time_after, detect_tresh, window_smooth)

n_MEA = size(multi_unit, 1);
n_reps = size(multi_unit, 2);

SpikeTrains = cell(n_MEA, n_reps);
for i_elec = 1:n_MEA
    
    d = squeeze(multi_unit(i_elec, :, :))';
    m = mean(d,2);
    dsub = d - m*ones(1, n_reps);
    
    for i_rep = 1:n_reps
        
        TimeAround = [(1:time_before) ((time_before + stim_duration):(time_before + stim_duration + time_after))];
        TimeStim = ((time_before+1) : (time_before + stim_duration) );
        
        Filtered = smooth(dsub(:,i_rep)',window_smooth,'lowess');
        
        MADrest = median(abs(dsub(TimeAround,i_rep) - Filtered(TimeAround)));
        MADstim = median(abs(dsub(TimeStim,i_rep) - Filtered(TimeStim)));
        
        Limit = [];
        Limit(TimeAround) = MADrest;
        Limit(TimeStim) = MADstim;
        Limit = Limit * detect_tresh;
        if length(Limit)>size(dsub,1)
            Limit = Limit(1:size(dsub,1));
        elseif length(Limit)<size(dsub,1)
            Limit(end+1:size(dsub,1)) = 0;
        end
        Limit = Limit(:);
        Limit = Filtered - Limit;
        Limit = Limit';
        
        Spikes = find(dsub(1:end-1,i_rep)'>Limit(1:end-1) & dsub(2:end,i_rep)'<=Limit(2:end))+1;
        SpikeTrains{i_elec, i_rep} = Spikes;
    end
end