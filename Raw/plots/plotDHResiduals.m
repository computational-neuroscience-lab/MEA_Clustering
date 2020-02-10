clear

% Params
exp_id = '20200131_dh';
dead_electrodes = [];
stim_electrodes = [127 128 255 256];
 
% Folders
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];
residual_file = [dataPath(), '/', exp_id, '/processed/DH/dh_residuals.mat'];

% Load
load(mea_file, 'Positions')
mea_map = double(Positions);

load(residual_file, 'residuals', 'time_spacing', 'stim_duration')        

plotMEA()
plotDataMEA(residuals, mea_map, 'blue', dead_electrodes)
title(residual_file, 'Interpreter', 'None')

residual = computeMEAResidual([dead_electrodes, stim_electrodes], residuals);
[dead_init, dead_end] = computeDeadIntervals(residual, time_spacing);

% Get Dead Interval around artifact Residuals
mea_rate = 20000;   % HzM
plotDeadIntervals(dead_init, dead_end, residual, time_spacing, stim_duration, mea_rate);
