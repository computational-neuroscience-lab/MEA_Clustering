clear

% Params
exp_id = '20200131_dh';

dh_sessions = "DHMulti";
dh_types = ["single", "test", "multi"];
dh_sessions_to_mask = [2 3 4];

dead_electrodes = [];
stim_electrodes = [127 128 255 256];

mea_rate = 20000;   % Hz
stim_duration = 0.5*mea_rate;
time_spacing = 0.2*mea_rate;
encoding = 'uint16';

% Inputs
raw_file = [dataPath(), '/', exp_id, '/sorted/CONVERTED.raw'];
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];
dh_times_file = [dataPath() '/' exp_id '/processed/DH/DHTimes.mat'];

% Outputs
residual_file_suffix = '_residuals.mat';
residuals_folder = [dataPath(), '/', exp_id, '/processed/DH/'];
dead_times_file = [dataPath(), '/', exp_id, '/sorted/dead_times.txt'];

% Load
load(dh_times_file, 'dhTimes')
load(mea_file, 'Positions')
mea_map = double(Positions);

% Compute Artifact Residuals
dead_times_artifacts = [];
for session_id = dh_sessions
    dh_struct = load(getDatasetMat, session_id);
    
    for type_id = dh_types
        dh_patterns = dh_struct.(session_id).repetitions.(type_id);
        
        for i_pattern = 1:numel(dh_patterns)
            dh_triggers = dh_patterns{i_pattern};
            
            % Compute the residuals if it had not been done before
            residual_file = [char(session_id) '_' char(type_id) '_' num2str(i_pattern) residual_file_suffix];
            if ~exist([residuals_folder '/' residual_file], 'file')
                
                % compute residuals and dead_time intervals
                elec_residuals = computeElectrodeResidual(raw_file, dh_patterns, stim_duration, time_spacing, mea_map, encoding);
                mea_residual = computeMEAResidual([stim_electrodes, dead_electrodes], elec_residuals);
                [dead_init, dead_end] = computeDeadIntervals(mea_residual, time_spacing);
                
                % save
                save([tmpPath '/' residual_file], 'dead_init', 'dead_end', 'time_spacing', 'stim_duration', 'mea_rate');
                save([tmpPath '/' residual_file], 'elec_residuals', 'mea_residual', '-append');
                movefile([tmpPath '/' residual_file], residuals_folder);
                
            % Otherwise, just load the dead times and use them
            else
                load([residuals_folder '/' residual_file], 'dead_init', 'dead_end');
                dead_times_artifacts = [dead_times_artifacts; computeDeadTimes(dh_triggers, dead_init, dead_end)];
            end
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

writematrix(dead_times, dead_times_file,'Delimiter','tab')