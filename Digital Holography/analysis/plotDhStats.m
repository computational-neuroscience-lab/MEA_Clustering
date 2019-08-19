close all
load(getDatasetMat, 'dh_models', 'dh_stats')

activation = dh_stats.activationSingle(dh_models.isModeled);
accuracy = dh_models.accuracies(dh_models.isModeled);
labels = string(find(dh_models.isModeled));

figure()
scatter(activation, accuracy, 'Filled')
label_xshift = .02;
text(activation + label_xshift, accuracy, labels)
xlabel("activation score")
ylabel("model accuracy (pearson corr coeff)")
title("RGCs Activation VS Predictability")

