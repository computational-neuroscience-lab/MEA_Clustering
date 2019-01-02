
% TODO




MovingBars = 89350000:103222000;
barsEvtTime = EvtTime(and(EvtTime >= MovingBars(1), EvtTime <= MovingBars(end)));
load('Bars/bars.mat', 'directions', 'centers')

% bars
rep_begin_time_20khz = [];
rep_end_time_20khz = [];

rep_begin_time_20khz_left = [];
rep_end_time_20khz_left = [];

rep_begin_time_20khz_right = [];
rep_end_time_20khz_right = [];

for d = 1:8
    c = 1;
    borders = find(diff([false; and(centers == c, directions == d); false]));
    starts = borders(1:2:numel(borders));
    ends = borders(2:2:numel(borders));

    rep_begin_time_20khz_left = [rep_begin_time_20khz_left, barsEvtTime(starts)];
    rep_end_time_20khz_left = [rep_end_time_20khz_left, barsEvtTime(ends)];
    
    c = 2;
    borders = find(diff([false; and(centers == c, directions == d); false]));
    starts = borders(1:2:numel(borders));
    ends = borders(2:2:numel(borders));

    rep_begin_time_20khz = [rep_begin_time_20khz, barsEvtTime(starts)];
    rep_end_time_20khz = [rep_end_time_20khz, barsEvtTime(ends)];
    
    c = 3;
    borders = find(diff([false; and(centers == c, directions == d); false]));
    starts = borders(1:2:numel(borders));
    ends = borders(2:2:numel(borders));

    rep_begin_time_20khz_right = [rep_begin_time_20khz_right, barsEvtTime(starts)];
    rep_end_time_20khz_right = [rep_end_time_20khz_right, barsEvtTime(ends)];   
end
save("Bars/Bars_RepetitionTimes.mat", 'bars_begin_time_20khz', 'bars_end_time_20khz');
save("Bars/Bars_RepetitionTimes.mat", 'bars_begin_time_20khz_left', 'bars_end_time_20khz_left', '-append');
save("Bars/Bars_RepetitionTimes.mat", 'bars_begin_time_20khz_right', 'bars_end_time_20khz_right', '-append');


