function [spots_ids] = getDHFramePatterns(experiment, fv_id, frames_ids)

load([dataPath '/' experiment '/processed/DH/DHFrames_' num2str(fv_id) '.mat'], 'UniqueFrames');
if exist('frames_ids', 'var')
    spots_ids = logical(UniqueFrames(frames_ids, :));
else
    spots_ids = logical(UniqueFrames);
end



