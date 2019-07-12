function spots_coords = getDHSpotsPositions(experiment, spots_pattern)

coordsFile = [dataPath() '/' experiment '/processed/DH/DHCoords.mat'];
load(coordsFile, 'PatternCoords_Laser');

if exist('spots_pattern', 'var')
    spots_coords = PatternCoords_Laser(logical(spots_pattern), :);
else
    spots_coords = PatternCoords_Laser;
end
