clear
load(getDatasetMat(), "dh", "dh_stats", "dh_models")

% indices = and(dh_stats.test.activation > 0.3, dh_stats.singles.activation > 0.3);
indices = dh_stats.singles.activation > -1;
neurons_spikes = dh.responses.test.spikeCounts(indices, :);
good_patterns = cellfun(@numel, neurons_spikes(1,:)) >= 12;
neurons_spikes = neurons_spikes(:, good_patterns);

models_predictions = dh_models.LNP.predictions(indices, :);
models_predictions = models_predictions(:, good_patterns);

[n_neurons, n_patterns] = size(neurons_spikes);
firingRates = zeros(n_neurons, n_patterns);
accuracies = zeros(n_neurons, 1);
for neuron = 1:n_neurons
    for pattern = 1:n_patterns
        firingRates(neuron,pattern) = mean(neurons_spikes{neuron,pattern});
    end
    corr_mat = corrcoef(models_predictions(neuron, :), firingRates(neuron, :));
    accuracies(neuron) = corr_mat(1,2);
end

cells_indices = find(indices);
activation = dh_stats.test.activation(indices);
crossedAccuracyTest(neurons_spikes, models_predictions, cells_indices, activation);

figure()
histogram(accuracies, 20)
ylabel("number of cells")
xlabel("model accuracy")