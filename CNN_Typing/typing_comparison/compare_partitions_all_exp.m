function table = compare_partitions_all_exp(set1, set2)

changeDataset(set1);
load(getDatasetMat, "experiments");
for experiment = [experiments{:}]
    entry = compare_partitions_by_exp(set1, set2, experiment);
    exp_label = strcat("exp", experiment);
    table.(exp_label) = entry;
end