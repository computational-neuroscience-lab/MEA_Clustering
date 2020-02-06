function spots_coords = getDHSpotsPositions(dh_session_label, spots_pattern)

s = load(getDatasetMat, dh_session_label);
if exist('spots_pattern', 'var')
    spots_coords = s.(dh_session_label).spots.coords_laser(spots_pattern, :);
else
    spots_coords = s.(dh_session_label).spots.coords_laser;
end
