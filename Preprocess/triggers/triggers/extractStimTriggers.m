function stim_triggers = extractStimTriggers(stimData, evt_threshold, dt_threshold, frame_rate)

if ~exist('frame_rate', 'var')
    frame_rate = 20000;  % Hz
end

EvtTime_init = find(stimData(1:end-1)<evt_threshold & stimData(2:end) >= evt_threshold )+1;
EvtTime_end = find(stimData(1:end-1)>evt_threshold & stimData(2:end)<=evt_threshold )+1;

if EvtTime_init(end) > EvtTime_end(end)
    EvtTime_init = EvtTime_init(1:end-1);
end
if EvtTime_end(1) < EvtTime_init(1)
    EvtTime_end = EvtTime_end(2:end);
end    

EvtIntervals = diff(EvtTime_init)/frame_rate;
DiscontinuityIndices = find(EvtIntervals > dt_threshold);

StimBegin_Indices = [1; DiscontinuityIndices + 1];
StimEnd_Indices = [DiscontinuityIndices; numel(EvtTime_init)];

stim_triggers = {};
for i_stim = 1:length(StimBegin_Indices)
    stim_triggers{i_stim}.evtTimes_begin = EvtTime_init(StimBegin_Indices(i_stim):StimEnd_Indices(i_stim));
    stim_triggers{i_stim}.evtTimes_end = EvtTime_end(StimBegin_Indices(i_stim):StimEnd_Indices(i_stim));
end

% Debug: show the longest time intervals found
% to make sure everything is ok
sortedIntervals = sort(EvtIntervals, 'descend');
longest_time_gaps_secs = sortedIntervals(1:20)
shortest_time_gaps_secs = sortedIntervals(end-20:end)