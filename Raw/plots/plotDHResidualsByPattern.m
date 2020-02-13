clear

% Params
exp_id = '20200131_dh';
mea_rate = 20000;   % Hz
stim_duration = 0.5*mea_rate;

dead_electrodes = [];
stim_electrodes = [127 128 255 256];
 
% Folders
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];
residual_file = [dataPath(), '/', exp_id, '/processed/DH/dh_residuals.mat'];

% Load
load(mea_file, 'Positions')
mea_map = double(Positions);

elec_residuals_tot = 0;
for session_id = dh_sessions    
    for type_id = dh_types        
        for i_pattern = 1:numel(dh_patterns)            
            residual_file = [char(session_id) '_' char(type_id) '_' num2str(i_pattern) residual_file_suffix];
            load(residual_file, 'elec_residuals', 'time_spacing', 'stim_duration')   
            elec_residuals_tot = elec_residuals_tot + elec_residuals;
        end
    end
end

plotMEA()
plotDataMEA(elec_residuals_tot, mea_map, 'blue', dead_electrodes)
title(residual_file, 'Interpreter', 'None')

mea_residual = computeMEAResidual([stim_electrodes, dead_electrodes], elec_residuals);
[dead_init, dead_end] = computeDeadIntervals(mea_residual, time_spacing);
plotDeadIntervals(dead_init, dead_end, mea_residual, time_spacing, stim_duration, mea_rate);
