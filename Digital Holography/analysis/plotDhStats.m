close all
load(getDatasetMat, 'dh_models', 'dh_stats')

activation = dh_stats.singles.activation;
accuracy = dh_stats.test.activation;
labels = string(1:numel(dh_stats.singles.activation));

figure()
scatter(activation, accuracy, 'Filled')
label_xshift = .02;
text(activation + label_xshift, accuracy, labels)
xlabel("activation score")
ylabel("model accuracy (pearson corr coeff)")
title("RGCs Activation VS Predictability")

