function spots_coords_image = getDHSpotsCoordsImg(experiment, fv_id, spots_pattern)

load([dataPath '/' experiment '/processed/DH/DHFrames_' num2str(fv_id) '.mat'], 'PatternImage');
if exist('spots_pattern', 'var')
    spots_coords_image = PatternImage(spots_pattern, :);
else
    spots_coords_image = PatternImage;
end
