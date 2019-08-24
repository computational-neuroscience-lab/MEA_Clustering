function [all, single, repeatead, uniques] = getDHSpotsRepetitions(dhTimes_init, dhTimes_end, dh_frames_mat)

load(dh_frames_mat, 'TotalBlock', 'BlockSign');
[frames, sequence2frames, order] = unique(TotalBlock', 'rows');

single_sequences = sum(logical(TotalBlock) > 0, 1) == 1;
multi_sequences = sum(logical(TotalBlock) > 0, 1) > 1;

single_idx = single_sequences(sequence2frames)';

multi_idx = multi_sequences(sequence2frames)';
repeated_idx = BlockSign(sequence2frames) & multi_idx;
unique_idx = ~BlockSign(sequence2frames) & multi_idx;


assert(length(dhTimes_init) == length(dhTimes_end));
assert(length(dhTimes_init) <= length(order));

if(length(dhTimes_init) < length(order))
    fprintf('\tWARNING: %i triggers expected, but only %i were found\n', length(order), length(dhTimes_init));
end

all.rep_begin = cell(1, max(order));
all.rep_end = cell(1, max(order));
all.frames = frames;

for t = 1:length(dhTimes_init)
    frame_id = order(t);
    all.rep_begin{frame_id} = [all.rep_begin{frame_id} dhTimes_init(t)];
    all.rep_end{frame_id} = [all.rep_end{frame_id} dhTimes_end(t)];
end

single.rep_begin = all.rep_begin(single_idx);
single.rep_end = all.rep_end(single_idx);
single.frames = frames(single_idx, :);

repeatead.rep_begin = all.rep_begin(repeated_idx);
repeatead.rep_end = all.rep_end(repeated_idx);
repeatead.frames = frames(repeated_idx, :);

uniques.rep_begin = all.rep_begin(unique_idx);
uniques.rep_end = all.rep_end(unique_idx);
uniques.frames = frames(unique_idx, :);