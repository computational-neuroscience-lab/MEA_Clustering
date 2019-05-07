function [matchTable, matchByCellsTable, matchGrid] = compare_partitions_all(set1, set2)

changeDataset(set1);
load(getDatasetMat, "experiments");
load(getDatasetMat, "classesTableNotPruned");
classes_set1 = [classesTableNotPruned([classesTableNotPruned.size] > 3).name];

matchTable = compare_partitions (set1, set2);
matchByExpsTable = compare_partitions_all_exp(set1, set2);

for i_class = 1:numel(classes_set1)
    class = classes_set1(i_class);
    
    for i_exp = 1:numel(experiments)
        expLabel = strcat("exp", experiments{i_exp});
        classLabel = regexprep(class, '\.', '_');

        matchByCellsTable.(classLabel)(i_exp).Experiment = experiments{i_exp};
        matchByCellsTable.(classLabel)(i_exp).(set2) = matchByExpsTable.(expLabel)(i_class).(set2);
        matchByCellsTable.(classLabel)(i_exp).score = matchByExpsTable.(expLabel)(i_class).score;
        
        matchGrid(i_class).(set1) = classes_set1{i_class};
        matchGrid(i_class).(expLabel) = matchByExpsTable.(expLabel)(i_class).(set2);
    end
end
