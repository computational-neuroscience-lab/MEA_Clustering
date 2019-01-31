function [PSTH,XPSTH,MeanPSTH] = doPSTH(SpikeTimes, EventTime, BinSize, NbBins, SamplingRate, CellNbs)
%SpikeTimes: the raster
%EventTime: the beginning of each repeat
%BinSize: in the same units than SpikeTimes and EventTime
%NbBins: number of bins
%SamplingRate: acquisition rate - 1/timestep of spike times
%CellNbs: which cells to pick in SpikeTimes for the psth estimation

%PSTH: the psth
%XPSTH: for a proper display, use plot(XPSTH,PSTH...
%MeanPSTH: average firing rate over the defined window

bin_edges = (0 : BinSize : NbBins*BinSize);
bin_centers = (BinSize/2 : BinSize : BinSize/2 + (NbBins - 1)*BinSize);

XPSTH = bin_centers / SamplingRate;
PSTH = zeros(length(CellNbs), NbBins);

for icell = 1:length(CellNbs)
    r = double(SpikeTimes{CellNbs(icell)});
    r = r(:);

    for rep_time = EventTime
            h = histcounts(r(:), rep_time + bin_edges);
            PSTH(icell, :) = PSTH(icell, :) + h;
    end
    
    PSTH(icell, :) = PSTH(icell, :) / length(EventTime);
    PSTH(icell, :) = PSTH(icell, :) / (BinSize/SamplingRate);
    MeanPSTH(icell) = mean(PSTH(icell, :));
end


