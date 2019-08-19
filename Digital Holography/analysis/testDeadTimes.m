function testDeadTimes(pattern_type)

load(getDatasetMat(), "params");

% Load Triggers of DH Spots
load(getDatasetMat(), "experiments");
assert(numel(experiments) == 1)
expId =  experiments{1};

dh_path = strcat(dataPath, "/", expId, "/processed/DHSpots/DHSpots_stim.mat");
dead_times_path = strcat(dataPath, "/", expId, "/processed/deadtimes.txt");
load(dh_path, "evtTimes")
load(dead_times_path)

dead_inits = deadtimes(:, 1);
dead_ends = deadtimes(:, 2);

% Get all Stim Repetitions
[r_repeated, ~, ~] = getSpotsRepetitions(evtTimes, pattern_type);
n_patterns = numel(r_repeated);
n_tot_repetitions = 0;
for r = r_repeated
    n_tot_repetitions = n_tot_repetitions + length(r{:});
end

r_initial_offset = -0.5; % s
r_length = 1.5;

% build figure with background rectangle representing holo stimulation

xlim([0, r_length])
ylim([0, n_tot_repetitions])

rect_color = [.6 .9 .9];
rect_edges = [-r_initial_offset, 0, -r_initial_offset, n_tot_repetitions];
rectangle('Position', rect_edges,'FaceColor', rect_color)
hold on

color_start = "green";
color_end = "red";

% add a stripe o spike trains for each pattern
i_row = 0;
for i_pattern = 1:numel(r_repeated)
    rs_init = r_repeated{i_pattern} + r_initial_offset * params.meaRate;
    rs_end = r_repeated{i_pattern} + (r_initial_offset + r_length) * params.meaRate;

    for r = 1:length(rs_init)
        i_row = i_row + 1;

        dead_init_segment = and(dead_inits > rs_init(r), dead_inits < rs_end(r));
        dead_init_rep = (dead_inits(dead_init_segment) - rs_init(r));
        dead_init_rep = dead_init_rep(:).';
        
        dead_end_segment = and(dead_ends > rs_init(r), dead_ends < rs_end(r));
        dead_end_rep = (dead_ends(dead_end_segment) - rs_init(r));
        dead_end_rep = dead_end_rep(:).';
        
        y_rep = ones(1, length(dead_init_rep)) * i_row;
        
        scatter(dead_init_rep / params.meaRate, y_rep, 25, color_start, 'filled')
        scatter(dead_end_rep / params.meaRate, y_rep, 25, color_end, 'filled')
    end        
end

set(gca,'ytick',[])
xlabel("DeadTimes (s)")
ylabel("Patterns")
title(strcat("Dead Times for , ", pattern_type, " patterns"))