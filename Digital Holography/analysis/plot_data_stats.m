close all
clear

load(getDatasetMat, "dh_stats")
load(getDatasetMat, "classesTable")
load(getDatasetMat, "clustersTable")
dh_stats.accuracies(dh_stats.accuracies < 0) = 0;

n_classes = numel(classesTable);
n_cells = numel(clustersTable);

avg_rates = mean(dh_stats.avg_rate_singles, 2);

pruned = getPrunedCells();

classes_labels = {classesTable.name};
pruned_label = "PRUNED";
plot_labels = [{pruned_label}, classes_labels];

classes_colors = getColors(n_classes);
cells_colors = ones(n_cells, size(classes_colors, 2)) * .8;
pruned_color = [.8, .8, .8];

% PLOTS
figure()
scatter(dh_stats.adaptation_rel(pruned), dh_stats.accuracies(pruned), 25, pruned_color, "filled")
hold on
for i_class = 1:n_classes
    class_members = classIndices(classes_labels{i_class});
    class_color = classes_colors(i_class, :);
    scatter(dh_stats.adaptation_rel(class_members), dh_stats.accuracies(class_members), 25, class_color, "filled")
end
xlabel("adaptation");
ylabel("model accuracy");
legend(plot_labels)
title("MODEL ACCURACY VS ADAPTATION (relative)")

figure()
scatter(dh_stats.adaptation_abs(pruned), dh_stats.accuracies(pruned), 25, pruned_color, "filled")
hold on
for i_class = 1:n_classes
    class_members = classIndices(classes_labels{i_class});
    class_color = classes_colors(i_class, :);
    scatter(dh_stats.adaptation_abs(class_members), dh_stats.accuracies(class_members), 25, class_color, "filled")
end
xlabel("adaptation");
ylabel("model accuracy");
legend(plot_labels)
title("MODEL ACCURACY VS ADAPTATION (absolute)")

figure()
scatter(avg_rates(pruned), dh_stats.accuracies(pruned), 25, pruned_color, "filled")
hold on
for i_class = 1:n_classes
    class_members = classIndices(classes_labels{i_class});
    class_color = classes_colors(i_class, :);
    scatter(avg_rates(class_members), dh_stats.accuracies(class_members), 25, class_color, "filled")
end
xlabel("average firing rate");
ylabel("model accuracy");
legend(plot_labels)
title("MODEL ACCURACY VS AVERAGE FIRING RATE")

figure()
scatter(dh_stats.quality_singles(pruned), dh_stats.accuracies(pruned), 25, pruned_color, "filled")
hold on
for i_class = 1:n_classes
    class_members = classIndices(classes_labels{i_class});
    class_color = classes_colors(i_class, :);
    scatter(dh_stats.quality_singles(class_members), dh_stats.accuracies(class_members), 25, class_color, "filled")
end
xlabel("quality index");
ylabel("model accuracy");
legend(plot_labels)
title("MODEL ACCURACY VS QUALITY")

figure()
scatter(dh_stats.activation(pruned), dh_stats.accuracies(pruned), 25, pruned_color, "filled")
hold on
for i_class = 1:n_classes
    class_members = classIndices(classes_labels{i_class});
    class_color = classes_colors(i_class, :);
    scatter(dh_stats.activation(class_members), dh_stats.accuracies(class_members), 25, class_color, "filled")
end
xlabel("activation");
ylabel("model accuracy");
legend(plot_labels)
title("MODEL ACCURACY VS ACTIVATION")


figure()
scatter(dh_stats.activation, dh_stats.adaptation_abs, 55, dh_stats.accuracies, "filled")
colorbar
xlabel("activation");
ylabel("adaptation");
title("ADAPTATION VS ACTIVATION")