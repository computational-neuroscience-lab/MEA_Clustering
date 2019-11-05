
% Params
exp_id = '20191011_grid';

dh_sessions_to_process = [3, 4, 5, 6];
dh_sessions_to_mask = [1, 2];

dead_electrodes = [198, 30];
stim_electrodes = [127 128 255 256];

mea_rate = 20000;   % Hz
stim_duration = 0.5*mea_rate;
time_spacing = 0.2*mea_rate;
encoding = 'uint16';

% Inputs
raw_file = [dataPath(), '/', exp_id, '/sorted/CONVERTED.raw'];
dh_times_file = [dataPath() '/' exp_id '/processed/DH/DHTimes.mat'];
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];

% Outputs
residuals_file = 'dh_residuals.mat';
residuals_folder = [dataPath(), '/', exp_id, '/processed/DH'];
dead_times_file = [dataPath(), '/', exp_id, '/sorted/dead_times.txt'];

% Load
load(dh_times_file, 'dhTimes')
load(mea_file, 'Positions')
mea_map = double(Positions);
    
% Compute Dead Times on dh session to mask completely:
dead_times_covered = zeros(numel(dh_sessions_to_mask), 2);
for i_dh = dh_sessions_to_mask
    dead_init = dhTimes{i_dh}.evtTimes_begin(1) - time_spacing;
    dead_end = dhTimes{i_dh}.evtTimes_end(end) + time_spacing;
    dead_times_covered(i_dh, :) =  [dead_init dead_end];
end

% Get All Triggers to process
triggers = [];
for i_dh = dh_sessions_to_process
    triggers = [triggers dhTimes{i_dh}.evtTimes_begin(:)'];
end

% Compute Artifact Residuals
try
    load([residuals_folder '/' residuals_file], 'residuals', 'triggers', 'stim_duration', 'time_spacing');
catch
    residuals = computeElectrodeResiduals(raw_file, triggers, stim_duration, time_spacing, mea_map, encoding);
    save([tmpPath '/' 'dh_residuals.mat'], 'residuals', 'triggers', 'stim_duration', 'time_spacing');
    movefile([tmpPath '/' 'dh_residuals.mat'], residuals_folder);
end
residual = computeMEAResidual([dead_electrodes, stim_electrodes], residuals);

% Plot Artifact Residual
plotMEA()
plotDataMEA(residuals, mea_map, 'blue', dead_electrodes)

% Get Dead Interval around artifact Residuals
[dead_init, dead_end] = computeDeadIntervals(residual, time_spacing);
plotDeadIntervals(dead_init, dead_end, residual, time_spacing, stim_duration, mea_rate);

% Compute Dead Times for artifact Residuals
dead_times_artifacts = computeDeadTimes(triggers, dead_init, dead_end);

% Put together and sort all dead times
dead_times = [dead_times_artifacts; dead_times_covered];
[~, order] = sort(dead_times(:,1));
dead_times = dead_times(order, :);

writematrix(dead_times, dead_times_file,'Delimiter','tab')