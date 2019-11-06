function extractDH(expId, dh_dt_max)

if ~exist('dh_dt_max', 'var')
    dh_dt_max = 4;
end

% input paths
expId = char(expId);
raw_file_path = [dataPath() '/' expId '/sorted/CONVERTED.raw'];

% output paths
dh_folder = [dataPath() '/' expId '/processed/DH'];

data_file = 'DHChannel_data.mat';
triggers_file = 'DHTimes.mat';
repetitions_file = 'DHRepetitions.mat';
coords_file = 'DHCoords.mat';

% Stim Triggers
try
    load([dh_folder '/' triggers_file], 'dhTimes')
    fprintf("DHtTimes Loaded\n\n")
catch
    try
        load([dh_folder '/' data_file], 'DHChannel_data')
    catch
        DHChannel_data = extractDataDH(raw_file_path);
        save([tmpPath '/' data_file], 'DHChannel_data', '-v7.3');
        movefile([tmpPath '/' data_file], dh_folder);
    end
    dhTimes = extractDHTriggers(DHChannel_data, dh_dt_max);
    save([tmpPath '/' triggers_file], 'dhTimes')
    movefile([tmpPath '/' triggers_file], dh_folder);
end

% Repetitions
% 
% get the repetition (in time steps) of the DH stimuli.
% singleSpot_reps: repetition of single-spot patterns
% multiSpots_reps: repetition of repeated multi-spot patterns
% multiSpots_uniques: times of non-repeated multi-spot patterns

zero_begin_time = [];
zero_end_time = [];
zero_frames = [];

single_begin_time = [];
single_end_time = [];
single_frames = [];

multi_begin_time = [];
multi_end_time = [];
multi_frames = [];

test_begin_time = [];
test_end_time = [];
test_frames = [];

PatternCoords_Laser = [];
PatternCoords_MEA = [];
PatternCoords_Img = [];

for i_dht = 1:numel(dhTimes)
    framesFile = [dataPath() '/' expId '/processed/DH/DHFrames_' num2str(i_dht) '.mat'];

    try
        % get the repetitions from different fields of view
        fprintf('Triggers set #%i:\n', i_dht);
        StimBegin = dhTimes{i_dht}.evtTimes_begin;
        StimEnd = dhTimes{i_dht}.evtTimes_end;        
        [zero_reps, single_reps, multi_reps, test_reps, all_reps] = getDHSpotsRepetitions(StimBegin, StimEnd, framesFile);

        % stack them together
        [n_spots, n_reps] = size(zero_frames);
        [n_new_spots, n_new_reps] = size(zero_reps.frames);
        zero_frames(n_spots+1 : n_spots+n_new_spots, n_reps+1 : n_reps+n_new_reps) = zero_reps.frames;
        zero_begin_time = [zero_begin_time, zero_reps.rep_begin];
        zero_end_time = [zero_end_time, zero_reps.rep_end];
        
        [n_spots, n_reps] = size(single_frames);
        [n_new_spots, n_new_reps] = size(single_reps.frames);
        single_frames(n_spots+1 : n_spots+n_new_spots, n_reps+1 : n_reps+n_new_reps) = single_reps.frames;
        single_begin_time = [single_begin_time, single_reps.rep_begin];
        single_end_time = [single_end_time, single_reps.rep_end];
        
        [n_spots, n_reps] = size(multi_frames);
        [n_new_spots, n_new_reps] = size(multi_reps.frames);
        multi_frames(n_spots+1 : n_spots+n_new_spots, n_reps+1 : n_reps+n_new_reps) = multi_reps.frames;
        multi_begin_time = [multi_begin_time, multi_reps.rep_begin];
        multi_end_time = [multi_end_time, multi_reps.rep_end];
        
        [n_spots, n_reps] = size(test_frames);
        [n_new_spots, n_new_reps] = size(test_reps.frames);
        test_frames(n_spots+1 : n_spots+n_new_spots, n_reps+1 : n_reps+n_new_reps) = test_reps.frames;
        test_begin_time = [test_begin_time, test_reps.rep_begin];
        test_end_time = [test_end_time, test_reps.rep_end];
        
        fprintf('\tDH repetitions generated\n\n');
        
        % stack the points coords
        
        % Points in laser coords are used to compute the light intensities
        load(framesFile, "PatternMicron", "PatternImage");
        PatternCoords_Laser = [PatternCoords_Laser; PatternMicron];
        PatternCoords_Img = [PatternCoords_Img; PatternImage];
        
        % Points in MEA coords are used to get their relative positions
        h = getHomography(['img' num2str(i_dht)], 'mea', expId);
        PatternCoords_MEA = [PatternCoords_MEA; transformPointsV(h, PatternImage)];
    catch e
        fprintf('\tnot possible to generate the DH repetitions:\n');
        fprintf('\t%s: %s\n', e.identifier, e.message);
    end
end

% Save the repetitions
save([tmpPath(), '/' repetitions_file], "zero_begin_time", "zero_end_time", "zero_frames");
save([tmpPath(), '/' repetitions_file], "single_begin_time", "single_end_time", "single_frames", "-append");
save([tmpPath(), '/' repetitions_file], "multi_begin_time", "multi_end_time", "multi_frames", "-append");
save([tmpPath(), '/' repetitions_file], "test_begin_time", "test_end_time", "test_frames", "-append");
save([tmpPath(), '/' coords_file], "PatternCoords_Laser", "PatternCoords_Img");
save([tmpPath(), '/' coords_file], "PatternCoords_MEA", "-append");

movefile([tmpPath(), '/' repetitions_file], dh_folder);
movefile([tmpPath(), '/' coords_file], dh_folder);
