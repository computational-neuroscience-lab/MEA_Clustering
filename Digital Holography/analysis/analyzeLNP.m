clear
close all

load(getDatasetMat, 'dh_models')
models_idx = dh_models.isModeled;
errors = sqrt(abs(dh_models.predictions(models_idx, :) - dh_models.firingRates(models_idx, :)));
mean_pattern_error = mean(errors, 1);
plot(sort(mean_pattern_error))
