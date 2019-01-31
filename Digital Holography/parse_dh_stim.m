clear
load("spots_stim.mat", "DH_Frames", "DH_Frames_nReps", "FramesOrder")

% Compute n. repetitions for each frame
DH_Frames_nReps = zeros(1, size(DH_Frames,1));
for i = 1:size(DH_Frames,1)
DH_Frames_nReps(i) = sum(FramesOrder==i);
end

% Find frame types
id_singles = find(sum(DH_Frames.') == 1);
id_unique = find(DH_Frames_nReps <= 3);
id_repeated = setdiff(find(DH_Frames_nReps > 3), id_singles);

save("spots_stim.mat", "DH_Frames", "DH_Frames_nReps", "FramesOrder")
save("spots_stim.mat", "id_singles", "id_unique", "id_repeated", "-append")