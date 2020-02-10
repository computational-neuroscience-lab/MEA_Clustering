clear

% Params
exp_id = '20200131_dh';

dh_labels_to_process = ["DHMulti"];
pattern_labels = ["single", "multi", "test"];
dh_sessions_to_mask = [];

dead_electrodes = [];
stim_electrodes = [127 128 255 256];

mea_rate = 20000;   % HzM
stim_duration = 0.5*mea_rate;
time_spacing = 0.2*mea_rate;
encoding = 'uint16';

% Inputs
dh_times_file = [dataPath() '/' exp_id '/processed/DH/DHTimes.mat'];
raw_file = [dataPath(), '/', exp_id, '/sorted/CONVERTED.raw'];
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];

% Outputs
residuals_file = 'dh_residuals.mat';
residuals_folder = [dataPath(), '/', exp_id, '/processed/DH/artifact_residuals/'];
dead_times_file = [dataPath(), '/', exp_id, '/sorted/dead_times.txt'];

% Load
load(dh_times_file, 'dhTimes')
load(mea_file, 'Positions')
mea_map = double(Positions);

% Try to load the residuals if they exist
try
    load([residuals_folder '/' residuals_file], 'stim_residuals', 'stim_duration', 'time_spacing');
end
    
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
    s = load(getDatasetMat, dh_label);
    
    for p_label = pattern_labels
        residual_file = [dh_label '_' p_label '_residuals.mat'];
        
        if ~exist([residuals_folder '/' residual_file], 'file')        
        
            stim_triggers = s.(dh_label).repetitions.(p_label);
            fprintf('%s patterns:\n', p_label);
            
            elec_residuals = computeElecStimResidual(raw_file, stim_triggers, stim_duration, time_spacing, mea_map, encoding);
            [mea_residual, dead_init, dead_end] = computeMEAStimResidual([stim_electrodes, dead_electrodes], elec_residuals, time_spacing);
            
            save([tmpPath '/' residual_file], 'elec_residuals', 'mea_residual', 'dead_init', 'dead_end');
            movefile([tmpPath '/' residual_file], residuals_folder);

            
%             for i_patterns = 1:numel(elec_residuals)
%                 % Plot Artifact Residual
%                 plotMEA()
%                 plotDataMEA(elec_residuals{i_patterns}/10, mea_map, 'blue', dead_electrodes)
% 
%                 % Get Dead Interval around artifact Residuals
%                 plotDeadIntervals(dead_init{i_patterns}, dead_end{i_patterns}, mea_residual{i_patterns}, time_spacing, stim_duration, mea_rate);
%                 waitforbuttonpress();
%                 close all
%             end
        end
    end
end


% Put all dead times together
dead_times_artifacts = [];

for dh_label = dh_labels_to_process
    s = load(getDatasetMat, dh_label);
    
    for p_label = pattern_labels
        residual_file = [dh_label '_' p_label '_residuals.mat'];
        load([tmpPath '/' residual_file], 'dead_init', 'dead_end');

        for i_patt = 1:numel(stim_residuals.(dead_init)
            di = dead_init{i_patt};
            de = dead_end{i_patt};
            stim_triggers = s.(dh_label).repetitions.(p_label);
            dead_times_artifacts = [dead_times_artifacts; computeDeadTimes(stim_triggers, di, de)];
        end
    end
end

% Compute Dead Times on dh session to mask completely:
dead_times_covered = zeros(numel(dh_sessions_to_mask), 2);
for i_dh = dh_sessions_to_mask
    dead_init = dhTimes{i_dh}.evtTimes_begin(1) - time_spacing;
    dead_end = dhTimes{i_dh}.evtTimes_end(end) + time_spacing;
    dead_times_covered(i_dh, :) =  [dead_init dead_end];
end

% Put together and sort all dead times
dead_times = [dead_times_artifacts; dead_times_covered];
[~, order] = sort(dead_times(:,1));
dead_times = dead_times(order, :);

writematrix(dead_times, dead_times_file, 'Delimiter', 'tab')