function [residuals, dead_inits, dead_ends]= computeMEAStimResidual(excluded_electrodes, elec_residuals, time_spacing)

residuals = cell(size(elec_residuals));
dead_inits = cell(size(elec_residuals));
dead_ends = cell(size(elec_residuals));

for i_p = 1:numel(elec_residuals) 
    residuals{i_p} = computeMEAResidual(excluded_electrodes, elec_residuals{i_p});
    [dead_init, dead_end] = computeDeadIntervals(residuals{i_p}, time_spacing);
    dead_inits{i_p} = dead_init;
    dead_ends{i_p} = dead_end;
end

