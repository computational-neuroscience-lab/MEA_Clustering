function testPSTH(SpikeTimes, rep_begin_time_20khz, rep_end_time_20khz, meaRate, tBin, Stim, StimRate)

% Test Consistency on Euler Stim
nSteps = rep_end_time_20khz(1) - rep_begin_time_20khz(1);
binSize = tBin * meaRate;
nTBins = round(nSteps / binSize);

[PSTH, XPSTH, ~] = doPSTH(SpikeTimes, rep_begin_time_20khz, binSize, nTBins, meaRate, 1:10);

Stim_X = cumsum(ones(1, length(Stim)) / StimRate) - 1/StimRate;
x_lim = max(Stim_X(end), XPSTH(end));
figure
subplot(2,1,1)
plot(XPSTH, PSTH)
xlim([0, x_lim])
subplot(2,1,2)
plot(Stim_X, Stim)
xlim([0, x_lim])
