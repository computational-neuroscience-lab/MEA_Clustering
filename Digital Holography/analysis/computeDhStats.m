load(getDatasetMat, 'dh', 'cellsTable')

n_cells = numel(cellsTable);
dh_stats.singles.activation =  zeros(n_cells, 1);
for i_cell = 1:n_cells
    pattern_counts = dh.responses.singles.spikeCounts(i_cell, :);
    pattern_counts = pattern_counts(cellfun(@numel, pattern_counts) >= 12);
    pattern_rates = cellfun(@mean, pattern_counts);
    pattern_vars = cellfun(@var, pattern_counts);
    
    activation_num = var(pattern_rates);
    activation_den = mean(pattern_vars);
    dh_stats.singles.activation(i_cell) = activation_num/activation_den;
end
dh_stats.singles.activation(isnan(dh_stats.singles.activation)) = 0;

dh_stats.test.activation =  zeros(n_cells, 1);
for i_cell = 1:n_cells
    pattern_counts = dh.responses.test.spikeCounts(i_cell, :);
    pattern_counts = pattern_counts(cellfun(@numel, pattern_counts) >= 12);
    pattern_rates = cellfun(@mean, pattern_counts);
    pattern_vars = cellfun(@var, pattern_counts);
    
    activation_num = var(pattern_rates);
    activation_den = mean(pattern_vars);
    dh_stats.test.activation(i_cell) = activation_num/activation_den;
end
dh_stats.test.activation(isnan(dh_stats.test.activation)) = 0;

dh_stats.all.activation =  zeros(n_cells, 1);
for i_cell = 1:n_cells
    pattern_counts = [dh.responses.singles.spikeCounts(i_cell, :), dh.responses.test.spikeCounts(i_cell, :)];
    pattern_counts = pattern_counts(cellfun(@numel, pattern_counts) >= 12);
    pattern_rates = cellfun(@mean, pattern_counts);
    pattern_vars = cellfun(@var, pattern_counts);
    
    activation_num = var(pattern_rates);
    activation_den = mean(pattern_vars);
    dh_stats.all.activation(i_cell) = activation_num/activation_den;
end
dh_stats.all.activation(isnan(dh_stats.all.activation)) = 0;


% dh_stats.errors = abs(dh_models.predictions - dh_models.spikeCount);

save(getDatasetMat, "dh_stats", "-append");