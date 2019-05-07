function isSplittable = clusterIsSplittable(indexesClass)

global cluster_split_size;
global cluster_split_psthSNR;
global cluster_split_staSNR;

sizeClass = length(indexesClass);
load(getDatasetMat(), "temporalSTAs", "psths");

norm_psths = psths(indexesClass, :) ./ max(psths(indexesClass, :), [], 2);

snr_psth = doSNR(norm_psths);
snr_sta = doSNR(temporalSTAs(indexesClass, :));

isSplittable = (sizeClass >= cluster_split_size) && ...
               (snr_psth <= cluster_split_psthSNR) && ...
               (snr_sta <= cluster_split_staSNR);
