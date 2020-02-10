function residuals = computeElecStimResidual(raw_file, stim_triggers, stim_duration, padding, mea_map, encoding)

mea_size = size(mea_map, 1);
residuals = cell(size(stim_triggers));

fprintf('computing residual artifact...\n')
for i_s = 1:numel(stim_triggers)
    stim_reps = stim_triggers{i_s};
    residuals{i_s} = zeros(mea_size, stim_duration + padding*2);
    for rep = stim_reps
        waves = extractDataMEA(raw_file, rep - padding, stim_duration + padding*2, mea_size, encoding);
        waves = reshape(waves, mea_size, stim_duration + padding*2);
        residuals(i_s) = max(residuals(i_s), abs(waves));
    end
    fprintf('\tpattern %i/%i completed...\n', i_s, numel(stim_triggers))
end
