clear

% Params
exp_id = '20200131_dh';

dh_labels_to_process = ["DHMulti"];
pattern_labels = ["single", "test", "multi"];
save_residuals = true;

dead_electrodes = [];
stim_electrodes = [127 128 255 256];

mea_rate = 20000;   % HzM
stim_duration = 0.5*mea_rate;
time_spacing = 0.2*mea_rate;
encoding = 'uint16';

% Inputs
raw_file = [dataPath(), '/', exp_id, '/sorted/CONVERTED.raw'];
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];

% Outputs
residuals_folder = [dataPath(), '/', exp_id, '/processed/DH/'];

% Load
load(mea_file, 'Positions')
mea_map = double(Positions);


% Compute Artifact Residuals
for dh_label = dh_labels_to_process
    s = load(getDatasetMat, dh_label);
    
    for p_label = pattern_labels
        residual_file = [char(dh_label) '_' char(p_label) '_residuals.mat'];
        
        if ~exist([residuals_folder '/' residual_file], 'file')        
            % get triggers
            stim_triggers = s.(dh_label).repetitions.(p_label);
            fprintf('%s patterns:\n', p_label);
            
            % compute residuals and dead_time intervals
            elec_residuals = computeElecStimResidual(raw_file, stim_triggers, stim_duration, time_spacing, mea_map, encoding);
            [mea_residual, dead_init, dead_end] = computeMEAStimResidual([stim_electrodes, dead_electrodes], elec_residuals, time_spacing);
            
            % save
            save([tmpPath '/' residual_file], 'dead_init', 'dead_end', 'time_spacing', 'stim_duration', 'mea_rate');
            if save_residuals
                save([tmpPath '/' residual_file], 'elec_residuals', 'mea_residual', '-append');
            end
            movefile([tmpPath '/' residual_file], residuals_folder);
        end
    end
end