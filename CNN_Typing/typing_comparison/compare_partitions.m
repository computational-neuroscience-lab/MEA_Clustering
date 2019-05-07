function table = compare_partitions (set1, set2)

% Get the classes of the 2 lists
changeDataset(set1);
load(getDatasetMat, "experiments");
load(getDatasetMat, "classesTableNotPruned");
classes_set1 = [classesTableNotPruned([classesTableNotPruned.size] > 3).name];

changeDataset(set2);
load(getDatasetMat, "classesTableNotPruned");
classes_set2 = [classesTableNotPruned([classesTableNotPruned.size] > 3).name];

% Build a comparison table
i_row = 0;
for class_set1 = classes_set1
    i_row = i_row + 1;
    best_score = 0;
    best_match = "";
    
    % retrieve class indices for set1
    changeDataset(set1);
    classIndices_set1 = classIndices(class_set1);
    
    changeDataset(set2);
    for class_set2 = classes_set2 
        
        % retrieve class indices for set2
        classIndices_set2 = classIndices(class_set2);
        
        % comparison between the couple of classes
        score = mcc_score(classIndices_set1, classIndices_set2);
        if score > best_score
            best_score = score;
            best_match = class_set2;
        end
    end
    
    table(i_row).(set1) = class_set1;
    table(i_row).(set2) = best_match;
    table(i_row).score = best_score;
end
