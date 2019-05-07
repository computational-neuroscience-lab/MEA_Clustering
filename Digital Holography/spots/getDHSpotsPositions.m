function spots_coords = getDHSpotsPositions(spots_pattern)

load(strcat(stimPath(), "/DHSpots/spots_coords"), "spots_coords_micron")
spots_coords = spots_coords_micron(spots_pattern, :);
