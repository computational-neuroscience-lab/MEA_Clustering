clear
close all

% Experiment Params
expId = '20170614';
varsPath = strcat(dataPath(), '/', expId, '/processed/');

% Load Data
load(strcat(varsPath, 'SpikeTimes.mat'), 'SpikeTimes')
load(strcat(varsPath,'EvtTimes.mat'), 'evtTimes')
load(strcat(varsPath,'Euler/Euler_RepetitionTimes.mat'), 'rep_begin_time_20khz', 'rep_end_time_20khz')

% PSTH Params
rate = 20000; % Hz
n_steps = rep_end_time_20khz(1) - rep_begin_time_20khz(1);
repetitions = rep_begin_time_20khz;

time_bin = 0.05; % s
bin_size = time_bin * rate;
n_bins = round(n_steps / bin_size);

n_cells = 1:numel(SpikeTimes);
time_res = 0.01;

% Test performance & efficiency of PSTH scripts
tic
[psth_b, xpsth_b, mean_psth_b, rs_b] = doPSTH(SpikeTimes, repetitions, bin_size, n_bins, rate, n_cells);
fprintf("binned PSTH: time = %f secs\n", toc);


tic
[psth_s, xpsth_s, mean_psth_s, rs_s] = doSmoothPSTH(SpikeTimes, repetitions, bin_size, n_bins, rate, n_cells, time_res);
fprintf("smooth PSTH: time = %f secs\n", toc);

% Plots
figure
subplot(2,1,1)
plot(xpsth_b, psth_b)
title("Binned PSTH")
subplot(2,1,2)
plot(xpsth_s, psth_s)
title("Smooth PSTH")
