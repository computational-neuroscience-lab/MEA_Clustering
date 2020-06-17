function dh_triggers = extractDHTriggers(stimData, dt_threshold, evt_threshold, frame_rate)

if ~exist('dt_threshold', 'var')
    dt_threshold = 10; % seconds
end

if ~exist('evt_threshold', 'var')
    evt_threshold = 500;
end

if ~exist('frame_rate', 'var')
    frame_rate = 20000;  % Hz
end

dh_triggers = extractStimTriggers(stimData, evt_threshold, dt_threshold, frame_rate);