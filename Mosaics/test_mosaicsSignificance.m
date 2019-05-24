close all
clear

loadDataset;
classes = [classesTableNotPruned.name];
exps = [experiments{:}];

my_exp = "20181018a";
my_class = "RGC.1.1.";
my_exp_idx = exps == my_exp;
my_class_idx = classes == my_class;

nnnds = mosaicNNNDs{my_class_idx, my_exp_idx};

plotClassMosaicStats(my_class, my_exp)

hnnnds = nullNNNDs{length(nnnds), my_exp_idx};
hcoverage = nullCoverage{length(nnnds), my_exp_idx};
hMosaic = nullMosaic{length(nnnds), my_exp_idx};

figure()
plotKSTest(nnnds, hnnnds);
title(strcat("KS Test ", my_class, " in ", my_exp), 'interpreter','none');


for i = 1:4
    [hh, hp, hk] = kstest2(hnnnds(i, :), hnnnds(:));
    label_set = strcat("random mosaic #", string(i));
    hcov = squeeze(hcoverage(i,:,:));
    hn = squeeze(hnnnds(i, :));
    hm = spatialSTAs(squeeze(hMosaic(i, :)));
    plotMosaicStats(label_set, my_exp, hcov, hm, [], hn, hnnnds, hp)
end


std_nh = std(hnnnds, 0, 2);
mean_nh = mean(hnnnds, 2); 

std_nnnds = std(nnnds); 
mean_nnnds = mean(nnnds); 

figure()
hold on
scatter(mean_nh, std_nh, 10, 'k')
scatter(mean_nnnds, std_nnnds, 25, 'r', 'filled')
xlabel('Mean')
ylabel('STD')