% script to extract the repetition times (in time steps) of DH stimuli

frames_mat = 'test_frames.mat'; % .mat file with TotalBlock and BlockSign
evt_times_mat = 'EvtTimes.mat'; % .mat file with (OPTIONAL)
raw_filename = 'DHBIPOL'; % .raw file with MEA data (ONLY NEEDED IF evt_times_mat IS NOT AVAILABLE)

try
    % load the triggers
    load(evt_times_mat, 'StimBegin', 'StimEnd')
catch
    % if the triggers aren't found, generate them
    dh_data = extractDH_Data([raw_filename '.raw']);
    dh_triggers = extractDHTriggers(dh_data);

    StimBegin = dh_triggers{1}.evtTimes_begin;
    StimEnd = dh_triggers{1}.evtTimes_end;
    save(evt_times_mat, 'StimBegin', 'StimEnd')
end

% get the repetition (in time steps) of the DH stimuli.
% all_reps: repetition of all DH patterns
% singleSpot_reps: repetition of single-spot patterns
% multiSpots_reps: repetition of repeated multi-spot patterns
% multiSpots_uniques: times of non-repeated multi-spot patterns

[all_reps, singleSpot_reps, multiSpots_reps, multiSpots_uniques] = getDHSpotsRepetitions(StimBegin, StimEnd, frames_mat);

% Save the repeated multi-spot repetitions
rep_begin_time = multiSpots_reps.rep_begin;
rep_end_time = multiSpots_reps.rep_end;
save([raw_filename '_multi.stim'], "rep_begin_time", "rep_end_time");
save([raw_filename '_reps_multi.mat'], "rep_begin_time", "rep_end_time");

% Save the single-spot repetitions
rep_begin_time = singleSpot_reps.rep_begin;
rep_end_time = singleSpot_reps.rep_end;
save([raw_filename '_single.stim'], "rep_begin_time", "rep_end_time");
save([raw_filename '_reps_single.mat'], "rep_begin_time", "rep_end_time");