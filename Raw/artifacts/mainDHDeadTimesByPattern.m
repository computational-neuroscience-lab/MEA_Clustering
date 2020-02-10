
% Params
exp_id = '20200131_dh';

dh_labels_to_process = ["DHMulti"];
dh_sessions_to_mask = [];

dead_electrodes = [];
stim_electrodes = [127 128 255 256];

mea_rate = 20000;   % Hz
stim_duration = 0.5*mea_rate;
time_spacing = 0.2*mea_rate;
encoding = 'uint16';

% Inputs
dh_times_file = [dataPath() '/' exp_id '/processed/DH/DHTimes.mat'];
raw_file = [dataPath(), '/', exp_id, '/sorted/CONVERTED.raw'];
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];

% Outputs
residuals_file = 'dh_residuals.mat';
residuals_folder = [dataPath(), '/', exp_id, '/processed/DH'];
dead_times_file = [dataPath(), '/', exp_id, '/sorted/dead_times.txt'];

% Load
load(dh_times_file, 'dhTimes')
load(mea_file, 'Positions')
mea_map = double(Positions);

% Try to load the residuals if they exist
load([residuals_folder '/' residuals_file], 'stim_residuals', 'stim_duration', 'time_spacing');
    
% Make sure the old parameters are the same
stim_duration_tmp = stim_duration;
time_spacing_tmp = time_spacing;
if (stim_duration_tmp ~= stim_duration) || (time_spacing_tmp ~= time_spacing) 
    error(' you are mixing residual artifacts computed with different parameters')
end

if ~exist('stim_residuals', 'var')
    stim_residuals = struct();
end

% Compute Artifact Residuals
for dh_label = dh_labels_to_process
    % for each dh_session compute the residuals if they do not exist yet
    if ~isfield(stim_residuals, dh_label)
        s = load(getDatasetMat, dh_label);
        pattern_labels = fieldnames(s.(dh_label).repetitions);
        for i_p = 1:numel(pattern_labels)
            p_label = pattern_labels{i_p};
            stim_triggers = s.(dh_label).repetitions.(p_label);
            elec_residuals = computeElecStimResidual(raw_file, stim_triggers, stim_duration, time_spacing, mea_map, encoding);
            mea_residual = computeMEAResidual([dead_electrodes, stim_electrodes], elec_residuals);
            stim_residuals.(dh_label).(p_label).elec_residuals = elec_residuals;
            stim_residuals.(dh_label).(p_label).mea_residual = mea_residual;
        end
    end
end

save([tmpPath '/' 'dh_residuals.mat'], 'stim_residuals', 'stim_duration', 'time_spacing');
movefile([tmpPath '/' 'dh_residuals.mat'], residuals_folder);
    
% Compute Dead Times on dh session to mask completely:
dead_times_covered = zeros(numel(dh_sessions_to_mask), 2);
for i_dh = dh_sessions_to_mask
    dead_init = dhTimes{i_dh}.evtTimes_begin(1) - time_spacing;
    dead_end = dhTimes{i_dh}.evtTimes_end(end) + time_spacing;
    dead_times_covered(i_dh, :) =  [dead_init dead_end];
end




% 
% 
% 
% % Plot Artifact Residual
% plotMEA()
% plotDataMEA(elec_residuals/10, mea_map, 'blue', dead_electrodes)
% 
% % Get Dead Interval around artifact Residuals
% [dead_init, dead_end] = computeDeadIntervals(mea_residual, time_spacing);
% plotDeadIntervals(dead_init, dead_end, mea_residual, time_spacing, stim_duration, mea_rate);
% 
% % Compute Dead Times for artifact Residuals
% dead_times_artifacts = computeDeadTimes(triggers, dead_init, dead_end);
% 
% % Put together and sort all dead times
% dead_times = [dead_times_artifacts; dead_times_covered];
% [~, order] = sort(dead_times(:,1));
% dead_times = dead_times(order, :);
% 
% writematrix(dead_times, dead_times_file,'Delimiter','tab')