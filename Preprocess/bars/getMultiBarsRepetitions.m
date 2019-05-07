function [rep_begin, rep_end] = getMultiBarsRepetitions(barsEvtTime, pattern_version)

if ~exist('pattern_version', 'var')
    pattern_version = '_180525';
end

bars_file = strcat(stimPath, '/Bars/DS_MEA', pattern_version, '.vec');
bars_vec = load(bars_file);
bars_seq = bars_vec(2:end, 5);

bars_direction = mod(bars_seq, 100).';
bars_center = (mod(bars_seq, 1000) - mod(bars_seq, 100)).' / 100;

for i_direction = unique(bars_direction)
    for i_center = unique(bars_center)
        rep_begin(i_direction, i_center) = ?
        rep_end(i_direction, i_center) = ?
    end
end

