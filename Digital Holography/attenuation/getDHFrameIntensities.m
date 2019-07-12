function frames_intensities = getDHFrameIntensities(experiment, patterns)

n_frames = size(patterns, 1);
n_spots = size(patterns, 2);

frames_intensities = zeros(n_frames, n_spots);
for i_pattern = 1:n_frames
    pattern = patterns(i_pattern, :);
    spots_coords = getDHSpotsPositions(experiment, pattern);
    intensity = patternIntensities(spots_coords(:, 1), spots_coords(:, 2));
    intensities = pattern .* intensity;
    frames_intensities(i_pattern, :) = intensities;
end

