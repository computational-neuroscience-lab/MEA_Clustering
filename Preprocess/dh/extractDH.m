function extractDH(expId)

% input paths
expId = char(expId);
rawFile = [dataPath() '/' expId '/sorted/CONVERTED.raw'];
dhTimesFile = [dataPath() '/' expId '/processed/DH/DHTimes.mat'];
dhDataFile = [dataPath() '/' expId '/processed/DH/DHChannel_data.mat'];

% output paths
repetitionsFile = [dataPath() '/' expId '/processed/DH/DHRepetitions.mat'];
coordsFile = [dataPath() '/' expId '/processed/DH/DHCoords.mat'];

% Stim Triggers
try
    load(dhTimesFile, 'dhTimes')
    fprintf("DHtTimes Loaded\n\n")
catch
    try
        load(dhDataFile, 'DHChannel_data')
    catch
        DHChannel_data = extractDH_Data(rawFile);
        save(dhDataFile, 'DHChannel_data', '-v7.3');
    end
    dhTimes = extractDHTriggers(DHChannel_data);
    save(dhTimesFile, 'dhTimes')
end

% Repetitions

% get the repetition (in time steps) of the DH stimuli.
% singleSpot_reps: repetition of single-spot patterns
% multiSpots_reps: repetition of repeated multi-spot patterns
% multiSpots_uniques: times of non-repeated multi-spot patterns

single_begin_time = [];
single_end_time = [];
single_frames = [];

multi_begin_time = [];
multi_end_time = [];
multi_frames = [];

unique_begin_time = [];
unique_end_time = [];
unique_frames = [];

PatternCoords_Laser = [];
PatternCoords_MEA = [];

for i_dht = 1:numel(dhTimes)
    framesFile = [dataPath() '/' expId '/processed/DH/DHFrames_' num2str(i_dht) '.mat'];

    try
        % get the repetitions from different fields of view
        fprintf('Triggers set #%i:\n', i_dht);
        StimBegin = dhTimes{i_dht}.evtTimes_begin;
        StimEnd = dhTimes{i_dht}.evtTimes_end;        
        [~, singleSpot_reps, multiSpots_reps, multiSpot_uniques] = getDHSpotsRepetitions(StimBegin, StimEnd, framesFile);
        
        % stack them together
        [n_spots, n_reps] = size(single_frames);
        [n_new_spots, n_new_reps] = size(singleSpot_reps.frames);
        single_frames(n_spots+1 : n_spots+n_new_spots, n_reps+1 : n_reps+n_new_reps) = singleSpot_reps.frames;
        single_begin_time = [single_begin_time, singleSpot_reps.rep_begin];
        single_end_time = [single_end_time, singleSpot_reps.rep_end];
        
        [n_spots, n_reps] = size(multi_frames);
        [n_new_spots, n_new_reps] = size(multiSpots_reps.frames);
        multi_frames(n_spots+1 : n_spots+n_new_spots, n_reps+1 : n_reps+n_new_reps) = multiSpots_reps.frames;
        multi_begin_time = [multi_begin_time, multiSpots_reps.rep_begin];
        multi_end_time = [multi_end_time, multiSpots_reps.rep_end];
        
        [n_spots, n_reps] = size(unique_frames);
        [n_new_spots, n_new_reps] = size(multiSpot_uniques.frames);
        unique_frames(n_spots+1 : n_spots+n_new_spots, n_reps+1 : n_reps+n_new_reps) = multiSpot_uniques.frames;
        unique_begin_time = [unique_begin_time, multiSpot_uniques.rep_begin];
        unique_end_time = [unique_end_time, multiSpot_uniques.rep_end];
        
        fprintf('\tDH repetitions generated\n\n');
        
        % stack the points coords
        
        % Points in laser coords are used to compute the light intensities
        load(framesFile, "PatternMicron", "PatternImage");
        PatternCoords_Laser = [PatternCoords_Laser; PatternMicron];
        
        % Points in MEA coords are used to get their relative positions
%         h = getHomography(['img' num2str(i_dht)], 'mea', expId);
%         PatternCoords_MEA = [PatternCoords_MEA; transformPointsV(h, PatternImage)];
    catch
        fprintf('\tnot possible to generate the DH repetitions\n\n');
    end
end

% Save the repetitions
save(repetitionsFile, "multi_begin_time", "multi_end_time", "multi_frames");
save(repetitionsFile, "single_begin_time", "single_end_time", "single_frames", "-append");
save(repetitionsFile, "unique_begin_time", "unique_end_time", "unique_frames", "-append");
% save(coordsFile, "PatternCoords_Laser", "PatternCoords_MEA");
