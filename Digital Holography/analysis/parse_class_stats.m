close all

% params
threshold = 0.10;

% load data
load(getDatasetMat, "dh_stats");
load(getDatasetMat, "cellsTable");
load(getDatasetMat, "classesTable");
n_classes = numel(classesTable);

quality_cells =  (mean(dh_stats.activation, 2) > threshold);

for i_class = 1:n_classes       
    class_indices = classesTable(i_class).indices;
    
    classesTable(i_class).adaptation = mean(dh_stats.adaptation_abs(class_indices));
    classesTable(i_class).activation = mean(dh_stats.activation(class_indices));
    classesTable(i_class).accuracy = mean(dh_stats.accuracies(class_indices));    
    classesTable(i_class).accuracy_std = std(dh_stats.accuracies(class_indices));  
    
    classesTable(i_class).qualities = mean(dh_stats.quality_singles(class_indices, :), 2);
    
    class_indices_q = classesTable(i_class).indices & quality_cells.';

    classesTable(i_class).q_adaptation = mean(dh_stats.adaptation_abs(class_indices_q));
    classesTable(i_class).q_activation = mean(dh_stats.activation(class_indices_q));
    classesTable(i_class).q_accuracy = mean(dh_stats.accuracies(class_indices_q));    
    classesTable(i_class).q_accuracy_std = std(dh_stats.accuracies(class_indices_q));    
    
end
save(getDatasetMat, "classesTable", "-append");

classes_labels = [classesTable.name];

figure
subplot(2,1,1)
hold on
bar([classesTable.accuracy]);
errorbar([classesTable.accuracy], [classesTable.accuracy_std]);
xticks(1:n_classes)
xticklabels(classes_labels)
title("all cells")
ylim([0,1])
ylabel("accuracy")

subplot(2,1,2)
hold on
bar([classesTable.q_accuracy]);
errorbar([classesTable.q_accuracy], [classesTable.q_accuracy_std]);
xticks(1:n_classes)
xticklabels(classes_labels)
ylim([0,1])
ylabel("accuracy")

title("good cells")


figure
classes_mean_adaptation_q = [classesTable.adaptation];

subplot(2,1,1)
bar([classesTable.adaptation]);
xticks(1:n_classes)
xticklabels([classesTable.name])
xticks(1:n_classes)
xticklabels(classes_labels)
ylabel("adaptation")
title("all cells")


subplot(2,1,2)
bar([classesTable.q_adaptation]);
xticks(1:n_classes)
xticklabels([classesTable.name])
xticks(1:n_classes)
xticklabels(classes_labels)
ylabel("adaptation")

title("good cells")
plotLeafTraces