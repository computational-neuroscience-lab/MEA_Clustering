function [spots_ids] = getDHFramePatterns(frames_ids)

load(strcat(stimPath, '/DHSpots/', 'spots_pattern.mat'), 'DH_Frames')
spots_ids = logical(DH_Frames(frames_ids, :));


