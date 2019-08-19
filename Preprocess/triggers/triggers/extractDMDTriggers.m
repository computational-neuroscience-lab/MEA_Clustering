function evtTimes = extractDMDTriggers(stimData, frame_rate)

if ~exist('frame_rate', 'var')
    frame_rate = 20000;  % Hz
end

evt_threshold = 3000;
dt_threshold = 3; % seconds
evtTimes = extractStimTriggers(stimData, evt_threshold, dt_threshold, frame_rate);