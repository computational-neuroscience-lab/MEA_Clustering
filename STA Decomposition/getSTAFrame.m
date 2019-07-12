function sta_frame = getSTAFrame(i_cell)

load(getDatasetMat, "stas");
smoothSTA = smoothSta(stas{i_cell});
sta_frame = std(smoothSTA, [], 3);

