function [psth_chunked, stim_chunked] = extractEulerChunks(psth, samplingPSTH, stim, samplingStim)

cliffs = find(diff(stim));
stepOn_sec = cliffs(1) / samplingStim;
stepOff_sec = cliffs(2) / samplingStim;
stepMid_sec = cliffs(3) / samplingStim;

onStart = stepOn_sec - 0.5;
onEnd = stepOn_sec + 1;
offStart = stepOff_sec;
offEnd = stepOff_sec + 1;
midStart = stepMid_sec;
midEnd = stepMid_sec + 22.5;

psth_chunked = [psth(:, round(onStart*samplingPSTH ): round(onEnd*samplingPSTH)), psth(:, round(offStart*samplingPSTH) : round(offEnd*samplingPSTH)), psth(:, round(midStart*samplingPSTH) : round(midEnd*samplingPSTH))];

stimWithTail = [stim; stim];
stim_chunked = [stim(round(onStart*samplingStim) : round(onEnd*samplingStim)); stim(round(offStart*samplingStim) : round(offEnd*samplingStim)); stimWithTail(round(midStart*samplingStim) : round(midEnd*samplingStim))];

