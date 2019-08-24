clear
close all
load(getDatasetMat(), "dh", "dh_models")

idx = find(dh_models.LNP_30spots.isModeled);
idx = idx([1,2,4,5,6,7]);
err_30 = mean(dh_models.LNP_30spots.accuracies(idx));
err_40 = mean(dh_models.LNP_40spots.accuracies(idx));
err_50 = mean(dh_models.LNP_50spots.accuracies(idx));
err_60 = mean(dh_models.LNP_60spots.accuracies(idx));
err_70 = mean(dh_models.LNP_70spots.accuracies(idx));
err_100 = mean(dh_models.LNP.accuracies(idx));

size_30 = dh_models.LNP_30spots.tr_len;
size_40 = dh_models.LNP_40spots.tr_len;
size_50 = dh_models.LNP_50spots.tr_len;
size_60 = dh_models.LNP_60spots.tr_len;
size_70 = dh_models.LNP_70spots.tr_len;
size_100 = 5901;

scatter([size_30 size_40 size_50 size_60 size_70 size_100], [err_30 err_40 err_50 err_60 err_70 err_100])
% 
% figure()
% plotCorrelation(dh_models.LNP_L1.mses, dh_models.LNP_plus_L1.mses, "LNP-L1", "LNP-plus-L1")
% 
% figure()
% plotCorrelation(dh_models.LNP_L1.accuracies, dh_models.LNP.accuracies, "LNP-L1", "LNP")
% title("Accuracies")
% 
% figure()
% subplot(1,2,1)
% plotCorrelation(dh_models.LNP_1S.mses, dh_models.LNP.mses, "LNP-Singles", "LNP")
% title("MSEs")
% subplot(1,2,2)
% plotCorrelation(dh_models.LNP_1S.accuracies, dh_models.LNP.accuracies, "LNP-Singles", "LNP")
% title("Accuracies")

% neurons_spikes = dh.responses.repeated.spikeCounts(dh_models.LNP.isModeled, :);
% models_predictions = dh_models.LNP.predictions(dh_models.LNP.isModeled, :);
% cells_indices = find(dh_models.LNP.isModeled);
% 
% crossedAccuracyTest(neurons_spikes, models_predictions, cells_indices)
