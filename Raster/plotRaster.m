function plotRaster(classId)

loadDataset;
indices = find(classIndices(classId));

rowCount = 1;
nn = [];
for i = 1:length(indices)
    
    nCell = cellsTable(indices(i)).N;
    expId = cellsTable(indices(i)).experiment;
    
    nn = [nn, nCell];
    
    repetitionsMat = strcat(projectPath, "/Experiments/", expId, "/Euler/RepetitionTimes.mat");
    stimMat = strcat(projectPath, "/Experiments/", expId, "/Euler/euler.mat");
    spikesMat = strcat(projectPath, "/Experiments/", expId, "/SpikeTimes.mat");

    load(repetitionsMat, "rep_begin_time_20khz", "rep_end_time_20khz")
    load(stimMat, "euler", "freqEuler")
    load(spikesMat, "SpikeTimes")

    spikes = SpikeTimes{nCell};
    spikes_tot = [];
    y_spikes_tot = [];
    
    for r = 1:length(rep_begin_time_20khz)
        spikes_segment = and(spikes > rep_begin_time_20khz(r), spikes < rep_end_time_20khz(r));
        spikes_rep = spikes(spikes_segment) - rep_begin_time_20khz(r);
        
        if size(spikes_rep, 1) > 1
            spikes_rep = spikes_rep.';
        end
        
        spikes_tot = [spikes_tot, squeeze(spikes_rep)];
        y_spikes_tot = [y_spikes_tot, ones(1, length(spikes_rep)) * rowCount];
        rowCount = rowCount + 1;
    end
    scatter(spikes_tot / 20000, y_spikes_tot, '.')
    hold on
end  

xlabel("time (s)")
    