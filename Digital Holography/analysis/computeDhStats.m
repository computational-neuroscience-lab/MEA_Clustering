load(getDatasetMat, 'dh', 'dh_models', 'cellsTable')

n_cells = numel(cellsTable);
dh_stats.activationSingle =  zeros(n_cells, 1);
for i_cell = 1:n_cells
    pattern_counts = dh.responses.singles.spikeCounts(i_cell, :);
    pattern_rates = cellfun(@mean, pattern_counts);
    pattern_vars = cellfun(@var, pattern_counts);
    
    activation_num = var(pattern_rates);
    activation_den = mean(pattern_vars);
    dh_stats.activationSingle(i_cell) = activation_num/activation_den;
end

dh_stats.activationMulti =  zeros(n_cells, 1);
for i_cell = 1:n_cells
    pattern_counts = dh.responses.repeated.spikeCounts(i_cell, :);
    pattern_rates = cellfun(@mean, pattern_counts);
    pattern_vars = cellfun(@var, pattern_counts);
    
    activation_num = var(pattern_rates);
    activation_den = mean(pattern_vars);
    dh_stats.activationMulti(i_cell) = activation_num/activation_den;
end

dh_stats.errors = abs(dh_models.predictions - dh_models.spikeCou;

save(getDatasetMat, "dh_stats", "-append");