function evtTimes = extractStimTriggers(stimData, evt_threshold, dt_threshold, frame_rate)

if ~exist('frame_rate', 'var')
    frame_rate = 20000;  % Hz
end

EvtTime = find(stimData(1:end-1)<evt_threshold & stimData(2:end) >= evt_threshold )+1;
EvtIntervals = diff(EvtTime);
DiscontinuityIndices = find(diff(EvtIntervals) > dt_threshold*frame_rate) + 1;

StimBegin_Indices = [1; DiscontinuityIndices + 1];
StimEnd_Indices = [DiscontinuityIndices; numel(EvtTime)];

evtTimes = {};
for i_stim = 1:length(StimBegin_Indices)
    evtTimes{i_stim} = EvtTime(StimBegin_Indices(i_stim):StimEnd_Indices(i_stim));
end

% Debug: show the longest time intervals found
% to make sure everything is ok
sortedIntervals = sort(EvtIntervals, 'descend');
longest_time_gaps_secs = sortedIntervals(1:20) / frame_rate