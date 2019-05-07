function [rep_begin, rep_end, rep_ids] = getSpotsRepetitions(evt_times, frame_type)

% Parameters
duration = 10000;
patterns_mat = strcat(stimPath, '/DHSpots/spots_pattern.mat');

% Load Variable
patterns_ids_variable = strcat('id_', frame_type);
load(patterns_mat, 'FramesOrder', patterns_ids_variable);
patterns_ids = eval(patterns_ids_variable);

n_frames = numel(evt_times);

count = 0;
for id = patterns_ids
    repetitions = evt_times(FramesOrder(1:n_frames) == id);
    if repetitions > 0
        count = count + 1;
        rep_begin{count} = repetitions;
        rep_end{count} = repetitions + duration;
        rep_ids(count) = id;
    end
end

