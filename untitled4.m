clear
changeDataset('20170614');
load(getDatasetMat(), 'dh', 'dh_models', 'dh_stats');
changeDataset('20170614_dh');
load(getDatasetMat(), 'DHMulti');
close all
dh_new = DHMulti.responses.multi.spikeCounts(1:85,:);
dh_old = dh.responses.multi.spikeCounts(1:85,:);


mateq = zeros(85, 3596);
for i_c = 1:85
    for i_p = 1:3596
        mateq(i_c, i_p) = all(dh_new{i_c, i_p} == dh_old{i_c, i_p});
    end
end
