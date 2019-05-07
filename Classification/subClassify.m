function subClassify(classes)

subdataset_id = strcat(getDatasetId, "_sub");
copyDataset(getDatasetId, subdataset_id);
changeDataset(subdataset_id);
load(getDatasetMat,"classesTableNotPruned");

labels2cells = containers.Map;
for i_class = 1:numel(classesTableNotPruned)
    label  = char(classesTableNotPruned(i_class).name);
    if  endsWith(label, '.')
        label = label(1:end-1);
    end
    labels2cells(label) = classesTableNotPruned(i_class).indices;
end

treeClassification(labels2cells, classes);



