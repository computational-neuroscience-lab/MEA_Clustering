function isAdmissible = clusterIsAdmissible(indexesClass)

global cluster_min_size;
global cluster_min_psthSNR;
global cluster_min_staSNR;


sizeClass = length(indexesClass);
load(getDatasetMat(), "temporalSTAs", "psths");

norm_psths = psths(indexesClass, :) ./ max(psths(indexesClass, :), [], 2);

snr_psth = doSNR(norm_psths);
snr_sta = doSNR(temporalSTAs(indexesClass, :));

isAdmissible = (sizeClass >= cluster_min_size) && ...
               (snr_psth >= cluster_min_psthSNR) && ...
               (snr_sta >= cluster_min_staSNR);