function evtTimes = extractDHTriggers(stimData, frame_rate)

if ~exist('frame_rate', 'var')
    frame_rate = 20000;  % Hz
end

evt_threshold = 100;
dt_threshold = 5; % seconds
evtTimes = extractStimTriggers(stimData, evt_threshold, dt_threshold, frame_rate);