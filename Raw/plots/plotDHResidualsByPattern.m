clear

% Params
exp_id = '20200131_dh';
dh_labels_to_process = "DHMulti";
pattern_labels = ["single", "test", "multi"];
dead_electrodes = [];

% Folders
mea_file = [dataPath() '/' exp_id '/PositionsMEA'];
residuals_folder = [dataPath(), '/', exp_id, '/processed/DH/'];

% Load
load(mea_file, 'Positions')
mea_map = double(Positions);

for dh_label = dh_labels_to_process
    
    for p_label = pattern_labels
        residual_file = [char(dh_label) '_' char(p_label) '_residuals.mat'];
        load([residuals_folder '/' residual_file], 'dead_init', 'dead_end', 'mea_residual', 'elec_residuals', 'time_spacing', 'stim_duration', 'mea_rate')        
            
        for i_patterns = 1:numel(elec_residuals)
            % Plot Artifact Residual
            plotMEA()
            plotDataMEA(elec_residuals{i_patterns}, mea_map, 'blue', dead_electrodes)
            title(residual_file, 'Interpreter', 'None')
            
            % Get Dead Interval around artifact Residuals
            mea_rate = 20000;   % HzM
            stim_duration = 0.5*mea_rate;
            time_spacing = 0.2*mea_rate;
            plotDeadIntervals(dead_init{i_patterns}, dead_end{i_patterns}, mea_residual{i_patterns}, time_spacing, stim_duration, mea_rate);
            title(residual_file, 'Interpreter', 'None')
            waitforbuttonpress();
            close all
        end
    end
end