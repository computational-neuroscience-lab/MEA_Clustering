function spots_coords = getDHSpotsCoordsImg(dh_session_label, spots_pattern)

s = load(getDatasetMat, dh_session_label);
if exist('spots_pattern', 'var')
    spots_coords = s.(dh_session_label).spots.coords_img(spots_pattern, :);
else
    spots_coords = s.(dh_session_label).spots.coords_img;
end