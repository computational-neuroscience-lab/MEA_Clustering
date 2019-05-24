load(getDatasetMat, 'classesTableNotPruned', 'experiments');
load(getDatasetMat, 'mosaicSignificances');
[idx_class, idx_exp] = find(~mosaicSignificances & ~isnan(mosaicPValues));

for count = 1:length(idx_class)
    class_id = classesTableNotPruned(idx_class(count)).name;
    exp_id = experiments{idx_exp(count)};
    plotClassMosaicStats(class_id, exp_id);
    saveas(gcf, strcat(regexprep(class_id, '\.', ','), '-', exp_id', '_MOSAIC'),'jpg')
    close
end
    