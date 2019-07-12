function spots_coords = getDHSpotsCoordsMEA(experiment, spots_pattern)

coordsFile = [dataPath() '/' experiment '/processed/DH/DHCoords.mat'];
load(coordsFile, 'PatternCoords_MEA');

if exist('spots_pattern', 'var')
    spots_coords = PatternCoords_MEA(logical(spots_pattern), :);
else
    spots_coords = PatternCoords_MEA;
end
