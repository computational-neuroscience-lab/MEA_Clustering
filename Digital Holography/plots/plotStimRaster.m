function plotStimRaster(spikes, reps_patterns, duration, offset, rate, labels, colors)

line_spacing = 3;

rep_length = duration + 2*offset;
n_patterns = numel(reps_patterns);

n_max_repetitions = 10;
% for reps = reps_patterns
%     n_max_repetitions = max(n_max_repetitions, numel(reps{:}));
% end
n_tot_repetitions = n_patterns * (n_max_repetitions + line_spacing);

% build figure with background rectangle representing holo stimulation
if ~exist('colors', 'var')
    colors = getColors(n_patterns);
end
xlim([0, rep_length])
ylim([-10, n_tot_repetitions])

rect_color = [.85 .9 .9];

hold on

set(gca,'ytick',[])
xlabel("Spike Times (s)")
ylabel("Patterns")

% add a stripe o spike trains for each pattern
i_row = 0;
% y_ticks = zeros(1, n_patterns);

for i_pattern = 1:n_patterns
    rs_init = reps_patterns{i_pattern} - offset * rate;
    rs_end = reps_patterns{i_pattern} + (- offset + rep_length) * rate;
    color = colors(i_pattern, :);
    
    rect_edges = [offset, i_row-1, duration, n_max_repetitions+1];
    rectangle('Position', rect_edges,'FaceColor', rect_color, 'EdgeColor', 'none')

    for r = 1:n_max_repetitions
        i_row = i_row + 1;
        
        if r <= numel(reps_patterns{i_pattern})
            spikes_segment = and(spikes > rs_init(r), spikes < rs_end(r));
            spikes_rep = (spikes(spikes_segment) - rs_init(r));
            spikes_rep = spikes_rep(:).';
            y_spikes_rep = ones(1, length(spikes_rep)) * i_row;
            scatter(spikes_rep / rate, y_spikes_rep, 3, color, 'Filled', 'o')
        end
    end  
    i_row = i_row + line_spacing;

    y_ticks(i_pattern) = i_row;  
end
% yticks(y_ticks)
% yticklabels(labels);

% add window
% line([offset, offset], [0, i_row], 'LineWidth', 1.5, 'Color', 'red'); 
% line([duration + offset, duration + offset], [0, i_row], 'LineWidth', 1.5, 'Color', 'red'); 

