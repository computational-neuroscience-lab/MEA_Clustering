function [rep_begin_time_20khz, rep_end_time_20khz] = getConsecutiveStimRepetitions(stimTimes, stim_n_steps)

% this works for 20khz sampling 
rep_begin_time_20khz = stimTimes(1 : stim_n_steps : end);
rep_end_time_20khz = stimTimes(stim_n_steps : stim_n_steps : end);
rep_begin_time_20khz = rep_begin_time_20khz(1 : length(rep_end_time_20khz));