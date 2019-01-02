function test_psth(rep_begin_time_20khz, rep_end_time_20khz, SpikeTimes, Stim, StimRate)

% Test Consistency on Euler Stim
params.meaRate = 20000; %Hz
params.nSteps = rep_end_time_20khz(1) - rep_begin_time_20khz(1) + (1 * params.meaRate);
    
params.tBin = 0.05; % s
params.binSize = params.tBin * params.meaRate;
params.nTBins = round(params.nSteps / params.binSize);

[PSTH, XPSTH, MeanPSTH] = doPSTH(SpikeTimes, rep_begin_time_20khz, params.binSize, params.nTBins, params.meaRate, 1:numel(SpikeTimes));

Stim_X = cumsum(ones(1, length(Stim)) / StimRate) - 1/StimRate;
x_lim = max(Stim_X(end), XPSTH(end));
figure
subplot(2,1,1)
plot(XPSTH, PSTH)
xlim([1,x_lim])
subplot(2,1,2)
plot(Stim_X, Stim)
xlim([1,x_lim])

